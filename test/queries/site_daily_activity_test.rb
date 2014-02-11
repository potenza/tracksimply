require 'test_helper'

class SiteDailyActivityTest < ActiveSupport::TestCase
  setup do
    @today = Time.zone.today

    # ensure that visits have created_at values across two different UTC dates
    visits(:one).update_attribute(:created_at, @today.beginning_of_day)
    visits(:two).update_attribute(:created_at, @today.end_of_day)
  end

  test "returns overall stats for visits and conversions" do
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, @today.to_s(:db), @today.to_s(:db), {}).query

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal @today, visits[0]
    assert_equal 2, visits[1]

    conversions = activity[:conversions].first
    assert_equal @today, conversions[0]
    assert_equal 1, conversions[1]
  end

  test "allows you to add visit-based filters for visits and conversions" do
    filters = { "keyword" => "my search term" }
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, @today.to_s(:db), @today.to_s(:db), filters).query

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal @today, visits[0]
    assert_equal 1, visits[1]

    conversions = activity[:conversions].first
    assert_equal @today, conversions[0]
    assert_equal 1, conversions[1]
  end

  test "allows you to add tracking link-based filters for visits and conversions" do
    filters = { "medium" => "Paid Search" }
    activity = SiteDailyActivity.new(sites(:one), users(:one).time_zone, @today.to_s(:db), @today.to_s(:db), filters).query

    assert_equal 2, activity.length

    visits = activity[:visits].first
    assert_equal @today, visits[0]
    assert_equal 2, visits[1]

    conversions = activity[:conversions].first
    assert_equal @today, conversions[0]
    assert_equal 1, conversions[1]
  end
end
