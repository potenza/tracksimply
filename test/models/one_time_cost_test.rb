require 'test_helper'

class OneTimeCostTest < ActiveSupport::TestCase
  include CostTest

  setup do
    @cost = costs(:onetime)
  end

  test "validates start_date" do
    @cost.start_date = nil
    @cost.valid?
    assert_equal ["can't be blank"], @cost.errors[:start_date]
  end

  test "#visit_cost returns nil" do
    assert_nil @cost.visit_cost
  end

  test "#charges returns array containing a single charge" do
    charges = @cost.charges
    assert_equal 1, charges.length

    charge = charges.first
    assert_equal @cost.amount, charge.amount
    assert_equal @cost.start_date.beginning_of_day, charge.datetime
  end
end
