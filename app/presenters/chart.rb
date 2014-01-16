module Chart
  def self.included(base)
    base.class_eval do
      attr_reader :site, :time_zone, :start_date, :end_date
    end
  end

  def initialize(site, time_zone: Rails.application.config.time_zone)
    @site = site
    @time_zone = time_zone
  end

  private

  # assumes start_date & end_date are strings
  def parse_dates(start_date, end_date)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end
end
