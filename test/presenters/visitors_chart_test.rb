require 'test_helper'

class VisitorsChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = VisitorsChart.new(site)
  end

  test "defaults to last 30 days of visits and conversions" do
    data = @chart.query("crap", "crap")
    assert_equal 30, data[:visits].length
    assert_equal 30, data[:conversions].length
  end

  test "returns a single day's visits and conversions" do
    expected = {:visits=>[[1388534400000, 0]], :conversions=>[[1388534400000, 0]]}
    data = @chart.query("2014-01-01", "2014-01-01")
    assert_equal expected, data
  end
end
