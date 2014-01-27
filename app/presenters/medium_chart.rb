class MediumChart
  include Chart

  attr_reader :medium

  def query(medium, start_date, end_date)
    @medium = medium
    set_date_range(start_date, end_date)
    generate_stats
  end

  private

  def generate_stats
    site.tracking_links.where(medium: medium).collect do |tracking_link|
      stats = tracking_link_stats(tracking_link)
      calculate_profit!(stats)
      calculate_visit_stats!(stats)
      calculate_conversion_stats!(stats)
      stats
    end
  end

  def tracking_link_stats(tracking_link)
    {
      token: tracking_link.token,
      medium: tracking_link.medium,
      campaign: tracking_link.campaign,
      source: tracking_link.source,
      ad_content: tracking_link.ad_content,
      visits: tracking_link.visits.where(created_at: date_range).count,
      conversions: tracking_link.conversions.where(created_at: date_range).count,
      cost: tracking_link.expenses.where(paid_at: date_range).sum(:amount),
      revenue: tracking_link.conversions.where(created_at: date_range).sum(:revenue)
    }
  end
end
