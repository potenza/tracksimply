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
      stats[:conversion_rate] = stats[:visits] > 0 && (stats[:conversions].to_f / stats[:visits].to_f * 100).round(2) || 0
      stats[:profit] = stats[:revenue] - stats[:cost]
      stats
    end
  end

  def medium_stats(medium)
    relation = site.tracking_links.where(medium: medium)
    {
      medium: medium,
      visits: relation.joins(:visits).where("visits.created_at" => date_range).count,
      conversions: relation.joins(:conversions).where("conversions.created_at" => date_range).count,
      cost: relation.joins(:expenses).where("expenses.created_at" => date_range).sum(:amount),
      revenue: relation.joins(:conversions).where("conversions.created_at" => date_range).sum(:revenue)
    }
  end
end
