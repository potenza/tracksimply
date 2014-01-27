module Chart
  def self.included(base)
    base.class_eval do
      attr_reader :site, :time_zone, :start_date, :end_date, :date_range
    end
  end

  def initialize(site, time_zone)
    @site = site
    @time_zone = time_zone
  end

  private

  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end

  def set_date_range(start_date, end_date)
    parse_dates(start_date, end_date)
    Time.use_zone(time_zone) do
      @date_range = @start_date.beginning_of_day..@end_date.end_of_day
    end
  end

  def calculate_profit!(stats)
    stats[:profit] = stats[:revenue] - stats[:cost]
  end

  def calculate_visit_stats!(stats)
    stats[:conversion_rate] = stats[:cost_per_visit] = stats[:revenue_per_visit] = 0
    if stats[:visits] > 0
      stats[:conversion_rate] = (stats[:conversions].to_f / stats[:visits].to_f * 100).round(2)
      stats[:cost_per_visit] = stats[:cost] / stats[:visits]
      stats[:revenue_per_visit] = stats[:revenue] / stats[:visits]
    end
  end

  def calculate_conversion_stats!(stats)
    stats[:cost_per_conversion] = stats[:revenue_per_conversion] = 0
    if stats[:conversions] > 0
      stats[:cost_per_conversion] = stats[:cost] / stats[:conversions]
      stats[:revenue_per_conversion] = stats[:revenue] / stats[:conversions]
    end
  end
end
