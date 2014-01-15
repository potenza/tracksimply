class MonthlyCost < Cost
  validates :start_date, presence: true

  def to_s
    "Monthly Payment"
  end

  def charges
    charges = []
    current_date = start_date
    final_date = end_date || Time.zone.today

    while current_date <= final_date
      charges << Charge.new(amount, current_date)
      current_date += 1.month
    end

    charges
  end
end
