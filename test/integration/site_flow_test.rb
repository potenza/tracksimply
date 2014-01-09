require "integration_test_helper"

class SiteFlowTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "add a site" do
    click_on "Add a Site", match: :first
    fill_in :site_name, with: "My Awesome Site"
    click_on "Create Site"
    assert_page_has_content page, "My Awesome Site has been added"
  end

  test "edit site" do
    click_on "My Site", match: :first
    click_on "Edit Site"
    fill_in :site_name, with: "My Awesome Site"
    click_on "Update Site"
    assert_page_has_content page, "My Awesome Site has been updated"
  end

  test "delete site" do
    click_on "My Site", match: :first
    click_on "Delete Site"
    assert_page_has_content page, "My Site has been deleted"
  end

  test "pixel code is displayed properly" do
    click_on "My Site", match: :first
    click_on "Conversion Code"
    assert_page_has_content page, %{<img src="#{ENV['HTTP_HOST']}/track/conversions?revenue=4.99" width="1" height="1">}
  end
end
