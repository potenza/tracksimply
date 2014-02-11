require 'test_helper'

class SiteTablePresenterTest < ActiveSupport::TestCase
  setup do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "medium", {}).query
    @data = SiteTablePresenter.new(results).data
  end

  test "calulates additional stats" do
    stats = @data.find { |row| row[:name] == "Paid Search" }

    assert_equal 8.99, stats[:profit]
    assert_equal 4.995, stats[:revenue_per_visit]
    assert_equal 0.50, stats[:cost_per_visit]
    assert_equal 50.0, stats[:conversion_rate]
    assert_equal 9.99, stats[:revenue_per_conversion]
    assert_equal 1.00, stats[:cost_per_conversion]
  end

  test "calulates totals" do
    stats = @data.find { |row| row[:name] == "Totals" }

    assert_equal 2, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 76.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal -66.01, stats[:profit].to_f
    assert_equal 4.995, stats[:revenue_per_visit]
    assert_equal 38, stats[:cost_per_visit]
    assert_equal 50.0, stats[:conversion_rate]
    assert_equal 9.99, stats[:revenue_per_conversion]
    assert_equal 76.00, stats[:cost_per_conversion]
  end
end
