class VisitorsChart
  include Chart

  def query(start_date, end_date)
    parse_dates(start_date, end_date)

    {
      visits: count(site.visits),
      conversions: count(site.conversions)
    }
  end

  private

  def count(relation)
    Time.use_zone(time_zone) do
      start_date.upto(end_date).map do |date|
        [
          date.strftime("%Q").to_i,
          relation.where(created_at: date.beginning_of_day..date.end_of_day).count
        ]
      end
    end
  end
end
