class PayPerClickCost < Cost
  validates :start_date, presence: false

  def to_s
    "Pay Per Click"
  end

  def visit_cost
    amount
  end
end
