class VisitsAndConversionsChart
  attr_reader :site, :time_zone, :start_date, :end_date

  def initialize(site, time_zone = "UTC")
    @site = site
    @time_zone = time_zone
  end

  def data(start_date = nil, end_date = nil)
    @start_date = start_date || Date.today - 29
    @end_date = end_date || Date.today
    {
      visits: count(site.visits),
      conversions: count(site.conversions)
    }
  end

  private

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
