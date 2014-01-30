require 'test_helper'

class Api::SitesControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :graph, id: sites(:one).id
    assert_redirected_to login_path
  end

  test "#graph" do
    get :graph, id: sites(:one).id, start_date: Time.zone.today, end_date: Time.zone.today
    assert_response :success

    assert_match /visits/, @response.body
    assert_match /conversions/, @response.body
  end

  test "#table" do
    get :table, id: sites(:one).id, aggregate_by: :media, start_date: Time.zone.today, end_date: Time.zone.today
    assert_response :success

    response = JSON.parse(@response.body)
    stats = response.last

    assert_equal "Totals", stats["name"]
    assert_equal 2, stats["visits"]
    assert_equal 1, stats["conversions"]
    assert_equal 76, stats["cost"].to_f
    assert_equal 9.99, stats["revenue"].to_f
    assert_equal -66.01, stats["profit"].to_f
    assert_equal 4.995, stats["revenue_per_visit"].to_f
    assert_equal 38, stats["cost_per_visit"].to_f
    assert_equal 50, stats["conversion_rate"]
    assert_equal 9.99, stats["revenue_per_conversion"].to_f
    assert_equal 76, stats["cost_per_conversion"].to_f
  end
end
