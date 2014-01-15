class OneTimeCost < Cost
  validates :start_date, presence: true

  def to_s
    "One-Time Payment"
  end
end
