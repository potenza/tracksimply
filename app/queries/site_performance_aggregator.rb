class SitePerformanceAggregator
  attr_reader :site, :date_range, :aggregate_by, :filters

  def initialize(site, time_zone, start_date, end_date, aggregate_by, filters)
    @site = site
    set_date_range(time_zone, start_date, end_date)
    @aggregate_by = aggregate_by
    @filters = filters || {}
  end

  def query
    aggregation_values.collect do |aggregation_value|
      rel = scope_relation_for_value(base_relation, aggregation_value)
      stats = {
        type: aggregate_by,
        name: (aggregation_value || "[no #{aggregate_by}]"),
        visits: rel
          .where("visits.created_at" => date_range)
          .count,
        conversions: rel
          .where("conversions.created_at" => date_range)
          .count,
        cost: rel
          .where("expenses.paid_at" => date_range)
          .sum(:amount),
        revenue: rel
          .where("conversions.created_at" => date_range)
          .sum(:revenue)
      }

      # some expenses aren't attached to a visit record. only append these when:
      # - aggregating on a tracking_link AND a visit filter isn't present
      # - it's a special catch-all for visits ([related costs])
      if (tracking_link_field?(aggregate_by) && !visit_filter_present?) || aggregation_value == "[related costs]"
        stats[:cost] += non_visit_based_expense_relation(aggregation_value).sum(:amount)
      end

      stats
    end
  end

  private

  def visit_field?(col)
    %[keyword sid].include? col
  end

  def tracking_link_field?(col)
    %[medium source campaign ad_content].include? col
  end

  def visit_filter_present?
    filters.has_key?(:keyword) || filters.has_key?(:sid)
  end

  def set_date_range(time_zone, start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)
    Time.use_zone(time_zone) do
      @date_range = start_date.beginning_of_day..end_date.end_of_day
    end
  end

  def aggregation_values
    if visit_field? aggregate_by
      values = base_relation.pluck("data -> '#{aggregate_by}'").uniq
      if !visit_filter_present?
        # add a catch-all for [related costs], but only when we're not
        # filtering for a on a visit-related field
        values.push("[related costs]")
      end
      values
    else
      base_relation.pluck(aggregate_by).uniq
    end
  end

  def base_relation
    @base_relation ||= begin
      relation = site.tracking_links
        .joins("LEFT JOIN visits ON visits.tracking_link_id = tracking_links.id")
        .joins("LEFT JOIN conversions ON conversions.visit_id = visits.id")
        .joins("LEFT JOIN expenses ON expenses.visit_id = visits.id")
      apply_filters!(relation)
    end
  end

  def non_visit_based_expense_relation(value)
    relation = site.tracking_links
      .joins(:expenses)
      .where("expenses.paid_at" => date_range)
      .where("expenses.visit_id" => nil)
    apply_filters!(relation)
    scope_relation_for_value(relation, value)
  end

  def apply_filters!(relation)
    filters.each do |column_name, column_value|
      column_value = nil if column_value.empty?
      if visit_field? column_name
        if relation.to_sql.match /visits/ # non_visit_based_expense_relation doesn't join on visits
          relation.merge! relation.where("visits.data @> hstore(:key, :value)", key: column_name, value: column_value)
        end
      else
        relation.merge! relation.where(column_name => column_value)
      end
    end
    relation
  end

  def scope_relation_for_value(relation, value)
    if visit_field? aggregate_by
      if relation.to_sql.match /visits/ # non_visit_based_expense_relation doesn't join on visits
        relation.where(["visits.data @> hstore(:key, :value)", key: aggregate_by, value: value])
      else
        relation
      end
    else
      relation.where("#{aggregate_by}" => value)
    end
  end
end
