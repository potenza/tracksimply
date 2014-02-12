require 'test_helper'

class SiteGraphPresenterTest < ActiveSupport::TestCase
  setup do
    @yesterday = Time.zone.yesterday
    @today = Time.zone.today
    @tomorrow = Time.zone.tomorrow
    results = SiteDailyActivity.new(sites(:one), users(:one).time_zone, @yesterday.to_s(:db), @tomorrow.to_s(:db), {}).query
    @data = SiteGraphPresenter.new(@yesterday.to_s(:db), @tomorrow.to_s(:db), results).data
  end

  test "ensures all dates in range are covered" do
    expected = {
      visits: [
        [@yesterday.strftime("%Q").to_i, 0],
        [@today.strftime("%Q").to_i, 3],
        [@tomorrow.strftime("%Q").to_i, 0]
      ],
      conversions: [
        [@yesterday.strftime("%Q").to_i, 0],
        [@today.strftime("%Q").to_i, 1],
        [@tomorrow.strftime("%Q").to_i, 0]
      ]
    }

    assert_equal expected, @data
  end
end
