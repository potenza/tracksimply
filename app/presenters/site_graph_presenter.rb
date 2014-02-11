class SiteGraphPresenter
  attr_reader :start_date, :end_date, :visits, :conversions, :results

  def initialize(start_date, end_date, query_results)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @visits = query_results[:visits]
    @conversions = query_results[:conversions]
    @results = {
      visits: [],
      conversions: []
    }
  end

  def data
    append_missing_dates
    results
  end

  private

  def append_missing_dates
    start_date.upto(end_date).each do |date|
      results[:visits] << [format_date(date), num_visits(date)]
      results[:conversions] << [format_date(date), num_conversions(date)]
    end
  end

  def format_date(date)
    date.strftime("%Q").to_i
  end

  def num_visits(date)
    visit = visits.find { |v| v.first == date }
    visit && visit.last || 0
  end

  def num_conversions(date)
    conversion = conversions.find { |c| c.first == date }
    conversion && conversion.last || 0
  end
end
