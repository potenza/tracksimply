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
      visits: visits,
      conversions: conversions,
    }
  end

  private

  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end

  def visits
    collect_results(visit_relation)
  end

  def conversions
    collect_results(conversion_relation)
  end

  def collect_results(relation)
    relation.collect { |res| [res.date.strftime("%Q").to_i, res.count] }
  end

  def visit_relation
    relation = Time.use_zone(time_zone) do
      Visit
        .select("date(visits.created_at) as date, count(*) as count")
        .group("date(visits.created_at)")
        .joins(:tracking_link)
        .where("tracking_links.site_id" => site.id)
        .where("visits.created_at" => start_date.beginning_of_day..end_date.end_of_day)
    end
    apply_filters!(relation).order("date")
  end

  def conversion_relation
    relation = Time.use_zone(time_zone) do
      Conversion
        .select("date(conversions.created_at) as date, count(*) as count")
        .group("date(conversions.created_at)")
        .joins(:visit)
        .joins(:tracking_link)
        .where("tracking_links.site_id" => site.id)
        .where("conversions.created_at" => start_date.beginning_of_day..end_date.end_of_day)
    end
    apply_filters!(relation).order("date")
  end

  def apply_filters!(relation)
    filters.each do |column_name, column_value|
      column_value = nil if column_value.empty?
      if %W[keyword sid].include?(column_name)
        relation.merge! relation.where("visits.#{column_name}" => column_value)
      else
        relation.merge! relation.where("tracking_links.#{column_name}" => column_value)
      end
    end
    relation
  end
end
