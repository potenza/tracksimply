require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"
    get :index
    assert_redirected_to login_path
  end

  test "requires admin" do
    cookies.signed[:auth_token] = users(:two).auth_token

    get :index
    assert_redirected_to sites_path

    get :new
    assert_redirected_to sites_path

    post :create, site_id: 1
    assert_redirected_to sites_path

    get :edit, site_id: 1, id: 1
    assert_redirected_to sites_path

    post :update, site_id: 1, id: 1
    assert_redirected_to sites_path

    delete :destroy, site_id: 1, id: 1
    assert_redirected_to sites_path
  end

  test "#index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "#new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "#create (success)" do
    assert_difference("User.count") do
      post :create, user: { first_name: "John", last_name: "Smith", email: "user@example.com", password: "my-password", password_confirmation: "my-password" }
    end
    assert_redirected_to users_path
    assert_equal 'John Smith has been added', flash[:notice]
  end

  test "#create (failure)" do
    assert_no_difference("User.count") do
      post :create, user: { email: "" }
    end
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :new
  end

  test "#edit" do
    get :edit, id: users(:one).id
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "#update (success)" do
    post :update, id: users(:one).id, user: { first_name: "Bob", last_name: "Smith", email: "user@example.com", password: "my-password", password_confirmation: "my-password" }
    assert_equal "Bob", assigns(:user).first_name
    assert_redirected_to users_path
    assert_equal 'Bob Smith has been updated', flash[:notice]
  end

  test "#update (failure)" do
    post :update, id: users(:one).id, user: { first_name: "" }
    assert_equal "John", users(:one).reload.first_name
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template :edit
  end

  test "#destroy" do
    assert_difference("User.count", -1) do
      delete :destroy, id: users(:one).id
    end
    assert_redirected_to users_path
    assert_equal "John Smith has been deleted", flash[:notice]
  end
end
