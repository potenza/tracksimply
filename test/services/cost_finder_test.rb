require 'test_helper'

class CostFinderTest < ActiveSupport::TestCase
  test "#find returns an empty array if nothing is found" do
    assert_equal [], CostFinder.new.find(Time.zone.today + 1.day)
  end

  test "#find should find costs that are scheduled for today" do
    costs = CostFinder.new.find

    assert_equal 2, costs.length

    one_time_cost = costs.find { |c| c.type == "OneTimeCost" }
    assert_equal 50.00, one_time_cost.amount
    assert_equal Time.zone.today, one_time_cost.start_date

    monthly_cost = costs.find { |c| c.type == "MonthlyCost" }
    assert_equal 25.00, monthly_cost.amount
    assert_equal Time.zone.today, monthly_cost.start_date
  end
end
