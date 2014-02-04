class SiteDailyActivity
  attr_reader :site, :time_zone, :start_date, :end_date, :filters

  def initialize(site, time_zone, start_date, end_date, filters)
    @site = site
    @time_zone = time_zone
    parse_dates(start_date, end_date)
    @filters = filters || {}
  end

  def query
    {
      visits: count(visits_relation),
      conversions: count(conversions_relation)
    }
  end

  private

  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end

  def visits_relation
    @visits_relation ||= if filters.empty?
      site.visits
    else
      site.visits.joins(:tracking_link)
    end
  end

  def conversions_relation
    @conversions_relation ||= if filters.empty?
      site.conversions
    else
      site.conversions.joins(:visit).joins(:tracking_link)
    end
  end

  def count(relation)
    apply_filters!(relation)
    Time.use_zone(time_zone) do
      start_date.upto(end_date).map do |date|
        [
          date.strftime("%Q").to_i,
          relation.where(created_at: date.beginning_of_day..date.end_of_day).count
        ]
      end
    end
  end

  def apply_filters!(relation)
    filters.each do |column_name, column_value|
      column_value = nil if column_value.empty?
      if %W[keyword sid].include?(column_name)
        relation.merge! relation.where("visits.data @> hstore(:key, :value)", key: column_name, value: column_value)
      else
        relation.merge! relation.where("tracking_links.#{column_name}" => column_value)
      end
    end
    relation
  end
end
