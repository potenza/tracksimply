require 'test_helper'

class MediaChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = MediaChart.new(site)
  end

  test "returns stats for a single medium" do
    data = @chart.query("Paid Search", Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal 1, data.length

    stats = data.first
    assert_equal "Paid Search", stats[:medium]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 100.0, stats[:conversion_rate]
    assert_equal 0.50, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal 9.49, stats[:profit]
  end

  test "ensure cost stats are from proper date" do
    # move expense to tomorrow
    expenses(:one).update_attribute(:paid_at, Time.zone.tomorrow.beginning_of_day)

    data = @chart.query("Paid Search", Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal 1, data.length

    stats = data.first
    assert_equal "Paid Search", stats[:medium]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 100.0, stats[:conversion_rate]
    assert_equal 0.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal 9.99, stats[:profit]
  end

  test "returns stats for an array of media" do
    data = @chart.query(TrackingLink::MEDIA, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db))
    assert_equal data.length, TrackingLink::MEDIA.length
  end
end
