class VisitorsChart
  include Chart

  def query(start_date, end_date, medium = nil)
    parse_dates(start_date, end_date)
    medium = ["tracking_links.medium = ?", medium] if medium
    {
      visits: count(site.visits.where(medium)),
      conversions: count(site.conversions.where(medium))
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
