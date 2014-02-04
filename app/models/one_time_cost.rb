class OneTimeCost < Cost
  validates :start_date, presence: true

  def to_s
    "One-Time Payment"
  end

  def charges
    if start_date <= Time.zone.today
      [Charge.new(amount, start_date.beginning_of_day)]
    else
      []
    end
  end
end
