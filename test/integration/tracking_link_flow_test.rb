require "integration_test_helper"

class TrackingLinkFlowTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
    click_on "My Site"
    click_on "Tracking Links"
  end

  test "add a tracking link" do
    click_on "Add a Tracking Link"
    fill_in :tracking_link_landing_page_url, with: "www.google.com"
    fill_in :tracking_link_campaign, with: "My Campaign"
    fill_in :tracking_link_source, with: "My Source"
    fill_in :tracking_link_medium, with: "My Medium"
    fill_in :tracking_link_ad_content, with: "My Ad Content"
    click_on "Create Tracking link"
    assert_page_has_content page, "has been added"
  end

  test "edit tracking link" do
    click_on tracking_links(:one).token
    click_on "Edit"
    fill_in :tracking_link_campaign, with: "My Awesome Campaign"
    click_on "Update Tracking link"
    assert_page_has_content page, "Tracking link #{tracking_links(:one).token} has been updated"
    assert_page_has_content page, "My Awesome Campaign"
  end

  test "delete tracking link" do
    click_on tracking_links(:one).token
    click_on "Delete"
    assert_page_has_content page, "Tracking link #{tracking_links(:one).token} has been deleted"
  end
end
