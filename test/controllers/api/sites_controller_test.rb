require 'test_helper'

class Api::SitesControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :visitors_chart, id: sites(:one).id
    assert_redirected_to login_path
  end

  test "#visitors_chart" do
    get :visitors_chart, id: sites(:one).id
    assert_response :success

    assert_match /visits/, @response.body
    assert_match /conversions/, @response.body
  end

  test "#media_chart" do
    get :media_chart, id: sites(:one).id
    assert_response :success

    response = JSON.parse(@response.body)
    stats = response.first

    assert_equal TrackingLink::MEDIA.first, stats["medium"]
    assert_equal 1, stats["visits"]
    assert_equal 1, stats["conversions"]
    assert_equal 100, stats["conversion_rate"]
    assert_equal 0.50, stats["cost"].to_f
    assert_equal 9.99, stats["revenue"].to_f
    assert_equal 9.49, stats["profit"].to_f
  end
end
