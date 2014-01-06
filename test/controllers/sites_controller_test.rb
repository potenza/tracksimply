require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    cookies.signed[:auth_token] = users(:one).auth_token
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :index
    assert_redirected_to login_path
  end

  test "most actions require admin" do
    cookies.signed[:auth_token] = users(:two).auth_token

    get :index
    assert_response :success

    get :new
    assert_redirected_to sites_path

    post :create
    assert_redirected_to sites_path

    get :show, id: sites(:one).id
    assert_response :success

    get :pixel, id: 1
    assert_redirected_to sites_path

    get :edit, id: 1
    assert_redirected_to sites_path

    post :update, id: 1
    assert_redirected_to sites_path

    delete :destroy, id: 1
    assert_redirected_to sites_path
  end

  test "#index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "#new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:site)
  end

  test "#create (success)" do
    assert_difference("Site.count") do
      post :create, site: { name: "My Site" }
    end
    assert_redirected_to site_path(assigns(:site))
    assert_equal 'My Site has been added', flash[:notice]
  end

  test "#create (failure)" do
    assert_no_difference("Site.count") do
      post :create, site: { email: "" }
    end
    assert_response :success
    assert_not_nil assigns(:site)
    assert_template :new
  end

  test "#show" do
    get :show, id: sites(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:clicks)
  end

  test "#pixel" do
    get :pixel, id: sites(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
  end

  test "#edit" do
    get :edit, id: sites(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
  end

  test "#update (success)" do
    post :update, id: sites(:one).id, site: { name: "My Awesome Site" }
    assert_equal "My Awesome Site", assigns(:site).name
    assert_redirected_to site_path(assigns(:site))
    assert_equal 'My Awesome Site has been updated', flash[:notice]
  end

  test "#update (failure)" do
    post :update, id: sites(:one).id, site: { name: "" }
    assert_equal "My Site", sites(:one).reload.name
    assert_response :success
    assert_not_nil assigns(:site)
    assert_template :edit
  end

  test "#destroy" do
    assert_difference("Site.count", -1) do
      delete :destroy, id: sites(:one).id
    end
    assert_redirected_to sites_path
    assert_equal "My Site has been deleted", flash[:notice]
  end
end
