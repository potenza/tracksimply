class Cost < ActiveRecord::Base
  TYPES = [
    ['Pay Per Click', "PayPerClickCost"],
    ['Monthly Payment', "MonthlyCost"],
    ['One-Time Payment', "OneTimeCost"]
  ]

  validates :amount, numericality: { greater_than: 0 }

  belongs_to :tracking_link

  def visit_cost
    0.00
  end
end
