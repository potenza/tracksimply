class MediaChart
  include Chart

  def query(start_date, end_date)
    set_date_range(start_date, end_date)
    generate_stats
  end

  private

  def generate_stats
    TrackingLink::MEDIA.collect do |medium|
      stats = medium_stats(medium)
      calculate_profit!(stats)
      calculate_visit_stats!(stats)
      calculate_conversion_stats!(stats)
      stats
    end
  end

  def medium_stats(medium)
    relation = site.tracking_links.where(medium: medium)
    {
      medium: medium,
      visits: relation.joins(:visits).where("visits.created_at" => date_range).count,
      conversions: relation.joins(:conversions).where("conversions.created_at" => date_range).count,
      cost: relation.joins(:expenses).where("expenses.paid_at" => date_range).sum(:amount),
      revenue: relation.joins(:conversions).where("conversions.created_at" => date_range).sum(:revenue)
    }
  end
end
