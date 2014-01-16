class OneTimeCost < Cost
  validates :start_date, presence: true

  def to_s
    "One-Time Payment"
  end

  def charges
    [Charge.new(amount, start_date.beginning_of_day)]
  end
end
