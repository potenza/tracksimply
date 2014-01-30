class SitePerformancePresenter
  attr_reader :query_results, :totals

  def initialize(query_results)
    @query_results = query_results
    @totals = {
      type: :totals,
      name: "Totals",
      visits: 0,
      conversions: 0,
      cost: 0,
      revenue: 0
    }
  end

  def data
    process_totals!(process_results)
  end

  private

  def process_results
    query_results.collect do |stats|
      add_to_totals(stats)
      calculate_profit!(stats)
      calculate_visit_stats!(stats)
      calculate_conversion_stats!(stats)
      stats
    end
  end

  def add_to_totals(stats)
    totals[:visits] += stats[:visits]
    totals[:conversions] += stats[:conversions]
    totals[:cost] += stats[:cost]
    totals[:revenue] += stats[:revenue]
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

  def process_totals!(stats)
    calculate_profit!(totals)
    calculate_visit_stats!(totals)
    calculate_conversion_stats!(totals)
    stats << totals
  end
end
