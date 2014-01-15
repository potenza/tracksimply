class PendingExpenseFinder
  PendingExpense = Struct.new(:amount, :date)

  attr_reader :charges, :expenses

  # charges: what we should have been charged based on the cost model
  # expenses: what we've actually recorded
  def initialize(charges, expenses)
    @charges = charges
    @expenses = expenses
  end

  def find
    charges.collect do |charge|
      if expenses.where(paid_at: charge.date).count == 0
        PendingExpense.new(charge.amount, charge.date)
      end
    end
  end
end
