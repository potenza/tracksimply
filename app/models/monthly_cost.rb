class MonthlyCost < Cost
  validates :start_date, presence: true

  def to_s
    "Monthly Payment"
  end
end
