require 'test_helper'

class SitePerformanceAggregatorTest < ActiveSupport::TestCase
  setup do
    @today = Time.zone.today.to_s(:db)
  end

  test "site stats aggregated by a tracking_link field" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "medium", {}).query

    expected = {
      "Blogs"=>{:type=>"medium",:visits=>1, :conversions=>0, :revenue=>0.0, :cost=>0.0},
      "Display Ads (Banner Ads)"=>{:type=>"medium",:visits=>0, :conversions=>0, :revenue=>0.0, :cost=>25.00},
      "Paid Search"=>{:type=>"medium",:visits=>2, :conversions=>1, :revenue=>9.99, :cost=>1.00},
      "Social Media"=>{:type=>"medium",:visits=>0, :conversions=>0, :revenue=>0.0, :cost=>50.0}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a visit field" do
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "keyword", {}).query

    expected = {
      "[empty]"=>{:type=>"keyword",:visits=>1, :conversions=>0, :revenue=>0.0, :cost=>0.0},
      "[other costs]"=>{:type=>"keyword",:visits=>0, :conversions=>0, :revenue=>0.0, :cost=>75.0},
      "my search term"=>{:type=>"keyword",:visits=>1, :conversions=>1, :revenue=>9.99, :cost=>0.5},
      "some other search term"=>{:type=>"keyword",:visits=>1, :conversions=>0, :revenue=>0.0, :cost=>0.5}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a tracking_link field and refined by a tracking link filter" do
    filters = { "medium" => "Paid Search" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "medium", filters).query

    expected = {
      "Paid Search"=>{:type=>"medium",:visits=>2, :conversions=>1, :revenue=>9.99, :cost=>1.00}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a visit field and refined by a tracking link filter" do
    filters = { "medium" => "Paid Search" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "keyword", filters).query

    expected = {
      "[other costs]"=>{:type=>"keyword", :visits=>0, :conversions=>0, :revenue=>0.0, :cost=>0.0},
      "my search term"=>{:type=>"keyword", :visits=>1, :conversions=>1, :revenue=>9.99, :cost=>0.5},
      "some other search term"=>{:type=>"keyword", :visits=>1, :conversions=>0, :revenue=>0.0, :cost=>0.5}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a tracking_link field and refined by a visit filter" do
    filters = { "keyword" => "my search term" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "medium", filters).query

    expected = {
      "Paid Search"=>{:type=>"medium",:visits=>1, :conversions=>1, :revenue=>9.99, :cost=>0.50}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a visit field and refined by a visit filter" do
    filters = { "keyword" => "my search term" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "keyword", filters).query

    expected = {
      "my search term"=>{:type=>"keyword",:visits=>1, :conversions=>1, :revenue=>9.99, :cost=>0.5}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a tracking link field and refined by a tracking link filter (with expenses, but no visits)" do
    filters = { "medium" => "Social Media" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "medium", filters).query

    expected = {
      "Social Media"=>{:type=>"medium",:visits=>0, :conversions=>0, :revenue=>0.0, :cost=>50.00}
    }

    assert_equal expected, results
  end

  test "site stats aggregated by a visit field and refined by a tracking link filter (with expenses, but no visits)" do
    filters = { "medium" => "Social Media" }
    results = SitePerformanceAggregator.new(sites(:one), users(:one).time_zone, @today, @today, "keyword", filters).query

    expected = {
      "[other costs]"=>{:type=>"keyword",:visits=>0, :conversions=>0, :revenue=>0.0, :cost=>50.00}
    }

    assert_equal expected, results
  end
end
