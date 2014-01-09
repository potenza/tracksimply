require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "#new" do
    get :new
    assert_nil assigns(:error)
    assert_response :success
  end

  test "#create (successful login) with remember me on" do
    post :create, email: users(:one).email, password: "my-password", remember_me: "1"
    assert_equal users(:one).auth_token, cookies.permanent.signed[:auth_token]
    assert_redirected_to sites_path
  end

  test "#create (successful login) with remember me off" do
    post :create, email: users(:one).email, password: "my-password"
    assert_equal users(:one).auth_token, cookies.signed[:auth_token]
    assert_redirected_to sites_path
  end

  test "#create (failed login)" do
    post :create, email: "blah", password: "blah"
    assert_equal nil, cookies.signed[:auth_token]
    assert_equal "Invalid email and or password combination.", assigns(:error)
    assert_template :new
  end

  test "#destroy" do
    cookies[:auth_token] = "auth-token"
    get :destroy
    assert_equal nil, cookies.signed[:auth_token]
    assert_redirected_to login_path
  end
end
