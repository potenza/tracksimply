class Cost < ActiveRecord::Base
  Charge = Struct.new(:amount, :datetime)

  TYPES = [
    ['Pay Per Click', "PayPerClickCost"],
    ['Monthly Payment', "MonthlyCost"],
    ['One-Time Payment', "OneTimeCost"]
  ]

  validates :amount, numericality: { greater_than: 0 }

  belongs_to :tracking_link

  def visit_cost
    nil
  end

  def charges
    []
  end
end
