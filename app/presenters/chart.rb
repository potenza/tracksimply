module Chart
  def self.included(base)
    base.class_eval do
      attr_reader :site, :time_zone, :start_date, :end_date
    end
  end

  def initialize(site, time_zone: "UTC")
    @site = site
    @time_zone = time_zone
  end

  private

  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  rescue
    # default to last 30 days
    Time.use_zone(time_zone) do
      @start_date = Time.zone.today - 29
      @end_date = Time.zone.today
    end
  end
end
