class MediaChart
  include Chart

  attr_reader :media, :date_range

  def query(media, start_date, end_date)
    media = [media] if media.kind_of? String
    @media = media
    set_date_range(start_date, end_date)
    generate_stats
  end

  private

  def set_date_range(start_date, end_date)
    parse_dates(start_date, end_date)
    Time.use_zone(time_zone) do
      @date_range = @start_date.beginning_of_day..@end_date.end_of_day
    end
  end

  def generate_stats
    media.collect do |medium|
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

  def calculate_profit!(stats)
    stats[:profit] = stats[:revenue] - stats[:cost]
  end

  def calculate_visit_stats!(stats)
    stats[:conversion_rate] = stats[:cost_per_visit] = stats[:revenue_per_visit] = 0
    if stats[:visits] > 0
      stats[:conversion_rate] = (stats[:conversions].to_f / stats[:visits].to_f * 100).round(2)
      stats[:cost_per_visit] = stats[:cost] / stats[:visits]
      stats[:revenue_per_visit] = stats[:revenue] / stats[:visits]
    end
  end

  def calculate_conversion_stats!(stats)
    stats[:cost_per_conversion] = stats[:revenue_per_conversion] = 0
    if stats[:conversions] > 0
      stats[:cost_per_conversion] = stats[:cost] / stats[:conversions]
      stats[:revenue_per_conversion] = stats[:revenue] / stats[:conversions]
    end
  end
end
