class SiteDailyActivity
  attr_reader :site, :time_zone, :start_date, :end_date, :filters

  def initialize(site, time_zone, start_date, end_date, filters)
    @site = site
    @time_zone = time_zone
    parse_dates(start_date, end_date)
    @filters = filters
  end

  def query
    {
      visits: count(site.visits),
      conversions: count(site.conversions)
    }
  end

  private

  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end

  def count(relation)
    Time.use_zone(time_zone) do
      start_date.upto(end_date).map do |date|
        [
          date.strftime("%Q").to_i,
          relation.where(created_at: date.beginning_of_day..date.end_of_day).count
        ]
      end
    end
  end
end
