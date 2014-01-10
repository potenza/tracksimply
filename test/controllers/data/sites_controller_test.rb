require 'test_helper'

class Data::SitesControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :visits_and_conversions, id: sites(:one).id
    assert_redirected_to login_path
  end

  test "#visits_and_conversions" do
    get :visits_and_conversions, id: sites(:one).id
    assert_response :success

    assert_match /visits/, @response.body
    assert_match /conversions/, @response.body
  end
end
