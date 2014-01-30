require 'test_helper'

class SitePerformanceAggregatorTest < ActiveSupport::TestCase
  test "returns performance stats for a site aggregated by tracking_link fields" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "medium", {}).query
    stats = results.find { |row| row[:name] == "Paid Search" }

    assert_equal "medium", stats[:type]
    assert_equal 2, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 1.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
  end

  test "supports aggregation by visit fields" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "keyword", {}).query
    stats = results.find { |row| row[:name] == "my search term" }

    assert_equal "keyword", stats[:type]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 0.50, stats[:cost]
    assert_equal 9.99, stats[:revenue]
  end

  test "includes non-visit-related costs for aggregations on visit fields" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "keyword", {}).query
    stats = results.find { |row| row[:name] == "[related costs]" }

    assert_equal "keyword", stats[:type]
    assert_equal 0, stats[:visits]
    assert_equal 0, stats[:conversions]
    assert_equal 75.00, stats[:cost]
    assert_equal 0.00, stats[:revenue]
  end

  test "includes non-visit-related stats for aggregations on visit fields (with no filters)" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "keyword", {}).query
    stats = results.find { |row| row[:name] == "[no keyword]" }

    assert_equal "keyword", stats[:type]
    assert_equal 1, stats[:visits]
    assert_equal 0, stats[:conversions]
    assert_equal 0.50, stats[:cost]
    assert_equal 0.00, stats[:revenue]
  end

  test "allows stats to be aggregated and refined by filters (visit-related)" do
    filters = { "keyword" => "my search term" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "keyword", filters).query

    assert_nil results.find { |row| row[:name] == "[no keyword]" }

    stats = results.find { |row| row[:name] == "my search term" }
    assert_equal "keyword", stats[:type]
    assert_equal 1, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 0.50, stats[:cost]
    assert_equal 9.99, stats[:revenue]

    stats = results.find { |row| row[:name] == "[related costs]" }
    assert_equal "keyword", stats[:type]
    assert_equal 0, stats[:visits]
    assert_equal 0, stats[:conversions]
    assert_equal 75, stats[:cost]
    assert_equal 0.00, stats[:revenue]
  end

  test "allows stats to be aggregate and refined by filters (non-visit related)" do
    filters = { "medium" => "Paid Search" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "medium", filters).query

    stats = results.first
    assert_equal "medium", stats[:type]
    assert_equal "Paid Search", stats[:name]
    assert_equal 2, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 1.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
  end
end
