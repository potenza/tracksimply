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

  test "#visit_cost returns nil" do
    assert_nil @cost.visit_cost
  end

  test "#charges returns array of charges" do
    @cost.start_date = Time.zone.today - 2.months
    charges = @cost.charges
    assert_equal 3, charges.length

    expense = charges.first
    assert_equal @cost.amount, expense.amount
    assert_equal Time.zone.today - 2.months, expense.date

    expense = charges.last
    assert_equal @cost.amount, expense.amount
    assert_equal Time.zone.today, expense.date
  end
end
