require 'test_helper'

class MonthlyCostTest < ActiveSupport::TestCase
  include CostTest

  setup do
    @cost = costs(:monthly)
  end

  test "validates start_date" do
    @cost.start_date = nil
    @cost.valid?
    assert_equal ["can't be blank"], @cost.errors[:start_date]
  end

  test "#visit_cost returns 0" do
    assert_equal 0.00, @cost.visit_cost
  end
end
