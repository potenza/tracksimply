require 'test_helper'

class ImportFormatsControllerTest < ActionController::TestCase
  setup do
    set_auth_token(users(:one))
    imports(:one).file.store!(File.open("test/fixtures/files/adwords.csv"))
    imports(:one).process!
  end

  test "requires user" do
    cookies.signed[:auth_token] = "bad-auth-token"

    get :index
    assert_redirected_to login_path
  end

  test "all actions requires admin" do
    cookies.signed[:auth_token] = users(:two).auth_token

    get :index
    assert_redirected_to sites_path

    get :new
    assert_redirected_to sites_path

    post :create
    assert_redirected_to sites_path

    delete :destroy, id: 1
    assert_redirected_to sites_path
  end

  test "#index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:import_formats)
  end

  test "#new" do
    get :new, import_id: imports(:one).id
    assert_response :success
    assert_not_nil assigns(:import_format)
    assert_not_nil assigns(:import)
    assert_not_nil assigns(:site)
  end

  test "#create (success)" do
    assert_difference("ImportFormat.count") do
      post :create, import_id: imports(:one).id, columns: { "0" => "date_column", "1" => "url_column", "2" => "cost_column" }, import_format: { file_type: "My Format" }
    end

    assert_equal assigns(:import_format).id, assigns(:import).import_format_id
    assert_redirected_to site_import_path(assigns(:site), assigns(:import))
  end

  test "#create (failure)" do
    assert_no_difference("ImportFormat.count") do
      post :create, import_id: imports(:one).id, columns: { }, import_format: { file_type: "" }
    end

    assert_template :new
    assert_not_nil assigns(:import_format)
    assert_not_nil assigns(:import)
    assert_not_nil assigns(:site)
  end

  test "#destroy" do
    assert_difference("ImportFormat.count", -1) do
      delete :destroy, id: import_formats(:one).id
    end
    assert_redirected_to import_formats_path
    assert_equal "Import Format deleted", flash[:notice]
  end
end
