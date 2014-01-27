require 'test_helper'

class MediaChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = MediaChart.new(site, users(:one).time_zone)
  end

  test "returns stats for all media" do
    data = @chart.query(Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal 10, data.length

    stats = data.first
    assert_equal "Paid Search", stats[:medium]
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

  test "ensure cost stats are from proper date" do
    # move expense to tomorrow
    expenses(:one).update_attribute(:paid_at, Time.zone.tomorrow.beginning_of_day)

    data = @chart.query(Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal 10, data.length

    stats = data.first
    assert_equal "Paid Search", stats[:medium]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 100.0, stats[:conversion_rate]
    assert_equal 0.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal 9.99, stats[:profit]
    assert_equal 0.00, stats[:cost_per_visit]
    assert_equal 9.99, stats[:revenue_per_visit]
    assert_equal 0.00, stats[:cost_per_conversion]
    assert_equal 9.99, stats[:revenue_per_conversion]
  end
end
