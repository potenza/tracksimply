require 'test_helper'

class VisitsAndConversionsChartTest < ActiveSupport::TestCase
  setup do
    site = sites(:one)
    @chart = VisitsAndConversionsChart.new(site)
  end

  test "returns last 30 days of visits and conversions" do
    data = @chart.data
    assert_equal 30, data[:visits].length
    assert_equal 30, data[:conversions].length
  end

  test "returns today's visits and conversions" do
    expected = {:visits=>[[1388534400000, 0]], :conversions=>[[1388534400000, 0]]}
    data = @chart.data(Date.parse("2014-01-01"), Date.parse("2014-01-01"))
    assert_equal expected, data
  end
end
