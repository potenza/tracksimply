require 'test_helper'

class Track::ClicksControllerTest < ActionController::TestCase
  test "#new creates a click record" do
    assert_difference("Click.count") do
      get :new, token: tracking_links(:one).token
    end
    assert_equal tracking_links(:one).site_id, assigns(:click).site_id
    assert_equal tracking_links(:one).id, assigns(:click).tracking_link_id
    assert_equal cookies.signed[:v_id], assigns(:click).visitor_id
    assert_equal "0.0.0.0", assigns(:click).details["ip_address"]
    assert_equal nil, assigns(:click).details["referrer"]
  end

  test "#new creates a visitor record and stores the id the cookie" do
    assert_difference("Visitor.count") do
      get :new, token: tracking_links(:one).token
    end
    assert_not_nil cookies.signed[:v_id]
  end

  test "#new doesn't create a new visitor record if the cookie already exists" do
    cookies.signed[:v_id] = visitors(:one).id
    assert_no_difference("Visitor.count") do
      get :new, token: tracking_links(:one).token
    end
  end

  test "#new redirects to the tracking link landing page" do
    get :new, token: tracking_links(:one).token
    assert_redirected_to tracking_links(:one).full_landing_page_url
  end
end
