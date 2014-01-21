require 'test_helper'

class ImportsControllerTest < ActionController::TestCase
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

    delete :destroy, site_id: 1, id: 1
    assert_redirected_to sites_path
  end

  test "#index" do
    get :index, site_id: imports(:one).site_id
    assert_response :success
    assert_not_nil assigns(:imports)
  end

  test "#new" do
    get :new, site_id: imports(:one).site_id
    assert_response :success
    assert_not_nil assigns(:import)
  end

  test "#create (success)" do
    assert_difference("Import.count") do
      file = fixture_file_upload("files/adwords.csv", "text/csv")
      post :create, site_id: imports(:one).site_id, import: { import_format_id: import_formats(:one).id, file: file }
    end

    assert_redirected_to site_import_path(assigns(:site), assigns(:import))
  end

  test "#create (failure)" do
    assert_no_difference("Import.count") do
      post :create, site_id: imports(:one).site_id, import: { import_format_id: "" }
    end

    assert_template :new
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:import)
  end

  test "#show" do
    get :show, site_id: imports(:one).site_id, id: imports(:one).id
    assert_response :success
    assert_not_nil assigns(:site)
    assert_not_nil assigns(:import)
  end

  test "#show redirect to import_format controller if no import format is found" do
    imports(:one).update_attribute(:import_format_id, nil)
    get :show, site_id: imports(:one).site_id, id: imports(:one).id
    assert_redirected_to new_import_format_path(import_id: imports(:one).id)
  end

  test "#destroy" do
    assert_difference("Import.count", -1) do
      delete :destroy, site_id: imports(:one).site_id, id: imports(:one).id
    end
    assert_redirected_to site_imports_path(assigns(:site))
    assert_equal "Import deleted", flash[:notice]
  end
end
