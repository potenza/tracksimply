class MediaChart
  include Chart

  def query(media, start_d, end_d)
    set_date_range(start_d, end_d)

    Time.use_zone(time_zone) do
      date_range = start_date.beginning_of_day..end_date.end_of_day

      media = [media] if media.kind_of? String
      media.collect do |medium|
        relation = site.tracking_links.where(medium: medium)

        visits = relation.joins(:visits).where("visits.created_at" => date_range).count
        conversions = relation.joins(:conversions).where("conversions.created_at" => date_range).count
        cost = relation.joins(:expenses).where("expenses.created_at" => date_range).sum(:amount)
        revenue = relation.joins(:conversions).where("conversions.created_at" => date_range).sum(:revenue)

        conversion_rate = visits > 0 && (conversions.to_f / visits.to_f * 100).round(2) || 0
        profit = revenue - cost

        {
          medium: medium,
          visits: visits,
          conversions: conversions,
          conversion_rate: conversion_rate,
          cost: cost,
          revenue: revenue,
          profit: profit
        }
      end
    end
  end
end
