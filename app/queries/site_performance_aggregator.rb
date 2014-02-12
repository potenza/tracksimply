class SitePerformanceAggregator
  attr_reader :site, :date_range, :aggregate_by, :filters

  def initialize(site, time_zone, start_date, end_date, aggregate_by, filters)
    @site = site
    set_date_range(time_zone, start_date, end_date)
    @aggregate_by = aggregate_by
    @filters = filters || {}
  end

  def query
    results = build_results_hash
    append_visit_data!(results)
    append_other_expenses!(results)
    results
  end

  private

  def build_results_hash
    hash = {}

    visits.each do |visit|
      hash[name_for(visit["aggregate_by"])] = empty_hash
    end

    other_expenses.each do |other_expense|
      name = name_for(other_expense["aggregate_by"])
      hash[name] = empty_hash unless hash.has_key? name
    end

    Hash[hash.sort]
  end

  def append_visit_data!(results)
    visits.each do |row|
      name = name_for(row["aggregate_by"])
      results[name][:visits] += row["visits_count"]
      results[name][:conversions] += row["conversions_count"]
      results[name][:revenue] += row["revenue"].to_f
      results[name][:cost] += row["amount"].to_f || 0.00
    end
  end

  def append_other_expenses!(results)
    other_expenses.each do |row|
      name = name_for(row["aggregate_by"])
      if results.has_key? name
        results[name][:cost] += row["amount"].to_f || 0.00
      end
    end
  end

  def visits
    @visits ||= begin
      relation = TrackingLink
        .select("DISTINCT(#{aggregate_by}) as aggregate_by, count(visits) as visits_count, count(conversions) as conversions_count, sum(revenue) as revenue, sum(expenses.amount) as amount")
        .joins("LEFT JOIN visits ON visits.tracking_link_id = tracking_links.id")
        .joins("LEFT JOIN conversions ON conversions.visit_id = visits.id")
        .joins("LEFT JOIN expenses ON expenses.visit_id = visits.id")
        .where("tracking_links.site_id" => site.id)
        .where("visits.created_at" => date_range)
        .group(aggregate_by)
        .order(aggregate_by)
      apply_filters(relation).all
    end
  end

  def other_expenses
    @other_expenses ||= begin
      if visit_filter_present?
        [] # no need to query for "other costs"
      else
        if visit_field?(aggregate_by)
          sum_non_visit_related_expenses
        else
          aggregate_non_visit_related_expenses
        end
      end
    end
  end

  def sum_non_visit_related_expenses
    relation = site.tracking_links
      .joins(:expenses)
      .where("expenses.paid_at" => date_range)
      .where("expenses.visit_id" => nil)
    amount = apply_filters(relation).sum(:amount)

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
    apply_filters(relation)
  end

  def set_date_range(time_zone, start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    Time.use_zone(time_zone) do
      @date_range = start_date.beginning_of_day..end_date.end_of_day
    end
  end

  def apply_filters(relation)
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

  def visit_filter_present?
    filters.has_key?("keyword") || filters.has_key?("sid")
  end

  def visit_field?(field)
    %w[keyword sid].include? field
  end

  def name_for(name)
    name || "[empty]"
  end

  def empty_hash
    {
      type: aggregate_by,
      visits: 0,
      conversions: 0,
      revenue: 0.00,
      cost: 0.00
    }
  end
end
