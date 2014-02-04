require 'test_helper'

class SiteDailyActivityTest < ActiveSupport::TestCase
  test "returns overall stats for visits and conversions" do
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), {}).query

    today = Time.zone.today.strftime("%Q").to_i

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal today, visits[0]
    assert_equal 2, visits[1]

    conversions = activity[:conversions].first
    assert_equal today, conversions[0]
    assert_equal 1, conversions[1]
  end

  test "allows you to add visit-based filters for visits and conversions" do
    filters = { "keyword" => "my search term" }
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), filters).query

    today = Time.zone.today.strftime("%Q").to_i

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal today, visits[0]
    assert_equal 1, visits[1]

    conversions = activity[:conversions].first
    assert_equal today, conversions[0]
    assert_equal 1, conversions[1]
  end

  test "allows you to add tracking link-based filters for visits and conversions" do
    filters = { "medium" => "Paid Search" }
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, Time.zone.today.to_s(:db), Time.zone.today.to_s(:db), filters).query

    today = Time.zone.today.strftime("%Q").to_i

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal today, visits[0]
    assert_equal 2, visits[1]

    conversions = activity[:conversions].first
    assert_equal today, conversions[0]
    assert_equal 1, conversions[1]
  end
end
