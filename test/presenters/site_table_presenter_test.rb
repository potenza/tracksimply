require 'test_helper'

class SiteTablePresenterTest < ActiveSupport::TestCase
  setup do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), "medium", {}).query
    @data = SiteTablePresenter.new(results).data
  end

  test "calulates additional stats" do
    expected = [
      {:type=>"medium", :visits=>1, :conversions=>0, :revenue=>0.0, :cost=>0.0, :name=>"Blogs", :profit=>0.0, :revenue_per_visit=>0.0, :cost_per_visit=>0.0, :conversion_rate=>0.0, :revenue_per_conversion=>0, :cost_per_conversion=>0},
      {:type=>"medium", :visits=>0, :conversions=>0, :revenue=>0.0, :cost=>25.0, :name=>"Display Ads (Banner Ads)", :profit=>-25.0, :revenue_per_visit=>0, :cost_per_visit=>0, :conversion_rate=>0, :revenue_per_conversion=>0, :cost_per_conversion=>0},
      {:type=>"medium", :visits=>2, :conversions=>1, :revenue=>9.99, :cost=>1.0, :name=>"Paid Search", :profit=>8.99, :revenue_per_visit=>4.995, :cost_per_visit=>0.5, :conversion_rate=>50.0, :revenue_per_conversion=>9.99, :cost_per_conversion=>1.0},
      {:type=>"medium", :visits=>0, :conversions=>0, :revenue=>0.0, :cost=>50.0, :name=>"Social Media", :profit=>-50.0, :revenue_per_visit=>0, :cost_per_visit=>0, :conversion_rate=>0, :revenue_per_conversion=>0, :cost_per_conversion=>0},
      {:type=>:totals, :name=>"Totals", :visits=>3, :conversions=>1, :cost=>76.0, :revenue=>9.99, :profit=>-66.01, :revenue_per_visit=>3.33, :cost_per_visit=>25.333333333333332, :conversion_rate=>33.33, :revenue_per_conversion=>9.99, :cost_per_conversion=>76.0}
    ]
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

    assert_equal 3, stats[:visits]
    assert_equal 1, stats[:conversions]
    assert_equal 76.00, stats[:cost]
    assert_equal 9.99, stats[:revenue]
    assert_equal -66.01, stats[:profit].to_f
    assert_equal 3.33, stats[:revenue_per_visit]
    assert_equal 25.333333333333332, stats[:cost_per_visit]
    assert_equal 33.33, stats[:conversion_rate]
    assert_equal 9.99, stats[:revenue_per_conversion]
    assert_equal 76.00, stats[:cost_per_conversion]
  end
end
