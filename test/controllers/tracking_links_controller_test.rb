require 'test_helper'

class TrackingLinksControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :index, site_id: 1
    assert_redirected_to login_path
  end

  test "all actions require admin" do
    cookies.signed[:auth_token] = users(:two).auth_token

    get :index, site_id: 1
    assert_redirected_to sites_path

    get :new, site_id: 1
    assert_redirected_to sites_path

    post :create, site_id: 1
    assert_redirected_to sites_path

    get :show, site_id: 1, id: 1
    assert_redirected_to sites_path

    get :edit, site_id: 1, id: 1
    assert_redirected_to sites_path

    post :update, site_id: 1, id: 1
    assert_redirected_to sites_path

    delete :destroy, site_id: 1, id: 1
    assert_redirected_to sites_path
  end

  test "#index" do
    get :index, site_id: tracking_links(:one).site_id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_links)
  end

  test "#new" do
    get :new, site_id: tracking_links(:one).site_id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_link)
    assert_not_nil assigns(:tracking_link).cost
    assert_equal "http://", assigns(:tracking_link).landing_page_url
  end

  test "#create (success)" do
    assert_difference("TrackingLink.count") do
      post :create, site_id: tracking_links(:one).site_id, tracking_link: {
        landing_page_url: "http://www.google.com",
        campaign: "my campaign",
        source: "my source",
        medium: TrackingLink::MEDIA.first,
        ad_content: "my ad content"
      }
    end
    assert_not_nil assigns(:site)
    assert_redirected_to site_tracking_link_path(assigns(:site), assigns(:tracking_link))
    assert_equal "Tracking link #{assigns(:tracking_link).token} has been added", flash[:notice]
  end

  test "#create (failure)" do
    assert_no_difference("TrackingLink.count") do
      post :create, site_id: tracking_links(:one).site_id, tracking_link: { landing_page_url: "" }
    end
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_link)
    assert_template :new
  end

  test "#show" do
    get :show, site_id: tracking_links(:one).site_id, id: tracking_links(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_link)
  end

  test "#edit" do
    get :edit, site_id: tracking_links(:one).site_id, id: tracking_links(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_link)
  end

  test "#update (success)" do
    post :update, site_id: tracking_links(:one).site_id, id: tracking_links(:one).id, tracking_link: {
      landing_page_url: "http://www.google.com",
      campaign: "my awesome campaign",
      source: "my source",
      medium: TrackingLink::MEDIA.first,
      ad_content: "my ad content"
    }
    assert_equal "my awesome campaign", tracking_links(:one).reload.campaign
    assert_redirected_to site_tracking_link_path(assigns(:site), assigns(:tracking_link))
    assert_equal "Tracking link #{assigns(:tracking_link).token} has been updated", flash[:notice]
  end

  test "#update (failure)" do
    post :update, site_id: tracking_links(:one).site_id, id: tracking_links(:one).id, tracking_link: {
      landing_page_url: "",
      campaign: "my awesome campaign"
    }
    assert_equal "My Campaign", tracking_links(:one).reload.campaign
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:tracking_link)
    assert_template :edit
  end

  test "#destroy" do
    assert_difference("TrackingLink.count", -1) do
      delete :destroy, site_id: tracking_links(:one).site_id, id: tracking_links(:one).id
    end
    assert_not_nil assigns(:site)
    assert_redirected_to site_tracking_links_path(assigns(:site))
    assert_equal "Tracking link #{tracking_links(:one).token} has been deleted", flash[:notice]
  end
end
