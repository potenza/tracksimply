class SitePerformanceAggregator
  attr_reader :site, :date_range, :aggregate_by, :filters

  def initialize(site, time_zone, start_date, end_date, aggregate_by, filters)
    @site = site
    set_date_range(time_zone, start_date, end_date)
    @aggregate_by = aggregate_by
    @filters = filters || {}
  end

  def query
    visits = visits_and_conversions

    if !visit_filter_present? && visit_field?(aggregate_by)
      visits.push({ "aggregate_by" => "[other costs]", "amount" => 0.00 })
    end

    visit_expenses = visit_related_expenses
    other_expenses = non_visit_related_expenses

    visits.collect do |row|
      aggregate_by_value = row["aggregate_by"]
      visit_expense = visit_expenses.find { |expense_row| expense_row["aggregate_by"] == aggregate_by_value }
      other_expense = other_expenses.find { |expense_row| expense_row["aggregate_by"] == aggregate_by_value }
      visit_expense = visit_expense && visit_expense["amount"] || 0.00
      other_expense = other_expense && other_expense["amount"] || 0.00
      expense = visit_expense + other_expense
      {
        type: aggregate_by,
        name: aggregate_by_value || "[empty]",
        visits: row["visits_count"] || 0,
        conversions: row["conversions_count"] || 0,
        revenue: row["revenue"] || 0.00,
        cost: expense
      }
    end
  end

  private

  def visit_field?(field)
    %w[keyword sid].include? field
  end

  def visit_filter_present?
    filters.has_key?(:keyword) || filters.has_key?(:sid)
  end

  def visits_and_conversions
    relation = TrackingLink
      .select("#{aggregate_by} aggregate_by, count(visits) as visits_count, count(conversions) as conversions_count, sum(revenue) as revenue")
      .group(aggregate_by)
      .joins("LEFT JOIN visits ON visits.tracking_link_id = tracking_links.id")
      .joins("LEFT JOIN conversions ON conversions.visit_id = visits.id")
      .where("tracking_links.site_id" => site.id)
      .where("visits.created_at" => date_range)
      .order(aggregate_by)
    apply_filters!(relation)
  end

  def visit_related_expenses
    relation = TrackingLink
      .select("#{aggregate_by} aggregate_by, sum(expenses.amount) as amount")
      .group(aggregate_by)
      .joins("LEFT JOIN visits ON visits.tracking_link_id = tracking_links.id")
      .joins("LEFT JOIN expenses ON expenses.visit_id = visits.id")
      .where("tracking_links.site_id" => site.id)
      .where("expenses.paid_at" => date_range)
      .order(aggregate_by)
    apply_filters!(relation)
  end

  def non_visit_related_expenses
    if visit_field? aggregate_by
      amount = site.tracking_links
        .joins(:expenses)
        .where("expenses.paid_at" => date_range)
        .where("expenses.visit_id" => nil)
        .sum("amount")

      [{
        "aggregate_by" => "[other costs]",
        "amount" => amount
      }]
    else
      relation = TrackingLink
        .select("#{aggregate_by} aggregate_by, sum(expenses.amount) as amount")
        .group(aggregate_by)
        .joins("LEFT JOIN expenses ON expenses.tracking_link_id = tracking_links.id")
        .where("tracking_links.site_id" => site.id)
        .where("expenses.visit_id IS NULL")
        .order(aggregate_by)
      apply_filters!(relation)
    end
  end

  def set_date_range(time_zone, start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    Time.use_zone(time_zone) do
      @date_range = start_date.beginning_of_day..end_date.end_of_day
    end
  end

  def apply_filters!(relation)
    filters.each do |column_name, column_value|
      column_value = nil if column_value.empty?
      if visit_field? column_name
        if relation.to_sql.match /visits/
          relation = relation.where("visits.#{column_name}" => column_value)
        end
      else
        relation = relation.where("tracking_links.#{column_name}" => column_value)
      end
    end
    relation
  end
end
