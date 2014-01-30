require 'test_helper'

class PendingExpenseFinderTest < ActiveSupport::TestCase
  test "#find returns an empty array if nothing is found" do
    tracking_link = tracking_links(:one) # ppc
    pending_expenses = PendingExpenseFinder.new(tracking_link.cost.charges, tracking_link.expenses).find
    assert_equal [], pending_expenses
  end

  test "#find locates past expenses that should exist" do
    tracking_link = tracking_links(:missingexpense)
    pending_expenses = PendingExpenseFinder.new(tracking_link.cost.charges, tracking_link.expenses).find

    pending_expense = pending_expenses.first
    assert_equal 100.00, pending_expense.amount
    assert_equal Time.zone.today.beginning_of_day, pending_expense.datetime
  end
end
