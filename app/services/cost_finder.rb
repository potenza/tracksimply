class CostFinder
  attr_reader :costs

  def initialize
    @costs = []
  end

  def find(date = Time.zone.today)
    costs.concat one_time_costs(date)
    costs.concat monthly_costs(date)
    costs
  end

  private

  def one_time_costs(date)
    OneTimeCost
      .includes(:tracking_link)
      .where(start_date: date)
  end

  def monthly_costs(date)
    MonthlyCost
      .includes(:tracking_link)
      .where("start_date::text like ? AND (end_date IS NULL OR end_date >= ?)", "%-#{date.strftime("%d")}", date)
  end
end
