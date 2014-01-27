require 'test_helper'

class MediumChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = MediumChart.new(site, users(:one).time_zone)
  end

  test "returns stats for all the tracking links in a medium" do
    data = @chart.query(TrackingLink::MEDIA.first, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal 1, data.length

    stats = data.first
    assert_equal tracking_links(:one).token, stats[:token]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 100.0, stats[:conversion_rate]
    assert_equal 0.50, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal 9.49, stats[:profit]
    assert_equal 0.50, stats[:cost_per_visit]
    assert_equal 9.99, stats[:revenue_per_visit]
    assert_equal 0.50, stats[:cost_per_conversion]
    assert_equal 9.99, stats[:revenue_per_conversion]
  end
end
