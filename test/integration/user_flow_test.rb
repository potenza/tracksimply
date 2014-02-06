require "integration_test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "add a user" do
    click_on "Users"
    click_on "New User"
    fill_in :user_first_name, with: "Bob"
    fill_in :user_last_name, with: "Smith"
    fill_in :user_email, with: "bobsmith@example.com"
    fill_in :user_password, with: "my-password"
    fill_in :user_password_confirmation, with: "my-password"
    click_on "Create User"
    assert_page_has_content page, "Bob Smith has been added"
  end

  test "edit user" do
    click_on "Users"
    click_on users(:one).name
    fill_in :user_first_name, with: "Steve"
    click_on "Update User"
    assert_page_has_content page, "Steve Smith has been updated"
  end

  test "delete user" do
    click_on "Users"
    click_on "Delete", match: :first
    assert_page_has_content page, "John Smith has been deleted"
  end
end
