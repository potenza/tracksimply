require 'test_helper'

class MediaChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = MediaChart.new(site)
  end

  test "returns stats for a single medium" do
    data = @chart.query("Social Media", "2014-01-01", "2014-01-01")
    assert_equal 1, data.length

    stats = data.first
    assert_equal "Social Media", stats[:medium]
    assert_equal 0, stats[:visits]
    assert_equal 0, stats[:conversions]
    assert_equal 0, stats[:conversion_rate]
    assert_equal 0.00, stats[:cost]
    assert_equal 0.00, stats[:revenue]
    assert_equal 0.00, stats[:profit]
  end

  test "returns stats for an array of media" do
    data = @chart.query(TrackingLink::MEDIA, "2014-01-01", "2014-01-01")
    assert_equal data.length, TrackingLink::MEDIA.length
  end
end
