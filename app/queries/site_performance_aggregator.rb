class SitePerformanceAggregator
  attr_reader :site, :date_range, :aggregate_by, :filters

  def initialize(site, time_zone, start_date, end_date, aggregate_by, filters)
    @site = site
    set_date_range(time_zone, start_date, end_date)
    @aggregate_by = aggregate_by
    @filters = filters || {}
  end

  def query
    visits.collect do |row|
      aggregate_by_value = row["aggregate_by"]
      cost = row["amount"] || 0.00
      cost += other_expense_for(aggregate_by_value)
      {
        type: aggregate_by,
        name: aggregate_by_value || "[empty]",
        visits: row["visits_count"] || 0,
        conversions: row["conversions_count"] || 0,
        revenue: row["revenue"] || 0.00,
        cost: cost
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

  def visits
    relation = TrackingLink
      .select("DISTINCT(#{aggregate_by}) as aggregate_by, count(visits) as visits_count, count(conversions) as conversions_count, sum(revenue) as revenue, sum(expenses.amount) as amount")
      .joins("LEFT JOIN visits ON visits.tracking_link_id = tracking_links.id")
      .joins("LEFT JOIN conversions ON conversions.visit_id = visits.id")
      .joins("LEFT JOIN expenses ON expenses.visit_id = visits.id")
      .where("tracking_links.site_id" => site.id)
      .where("visits.created_at" => date_range)
      .group(aggregate_by)
      .order(aggregate_by)
    visits = apply_filters!(relation).all

    if visit_field?(aggregate_by) && !visit_filter_present?
      # add a placeholder for other costs
      visits.push({ "aggregate_by" => "[other costs]", "amount" => 0.00 })
    end

    visits
  end

  def other_expense_for(aggregate_by_value)
    @other_expenses ||= begin
      if visit_field? aggregate_by
        sum_non_visit_related_expenses
      else
        aggregate_non_visit_related_expenses
      end
    end
    expense = @other_expenses.find { |row| row["aggregate_by"] == aggregate_by_value }
    expense && expense["amount"] || 0.00
  end

  def sum_non_visit_related_expenses
    amount = site.tracking_links
      .joins(:expenses)
      .where("expenses.paid_at" => date_range)
      .where("expenses.visit_id" => nil)
      .sum("amount")

    [{
      "aggregate_by" => "[other costs]",
      "amount" => amount
    }]
  end

  def aggregate_non_visit_related_expenses
    relation = TrackingLink
      .select("DISTINCT(#{aggregate_by}) as aggregate_by, sum(expenses.amount) as amount")
      .joins("LEFT JOIN expenses ON expenses.tracking_link_id = tracking_links.id")
      .where("tracking_links.site_id" => site.id)
      .where("expenses.visit_id IS NULL")
      .group(aggregate_by)
      .order(aggregate_by)
    apply_filters!(relation)
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
