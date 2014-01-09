require "integration_test_helper"

class VisitsAndConversionsTest < ActionDispatch::IntegrationTest
  test "tracking link visit and conversion" do
    Visit.destroy_all
    visit "/r/#{tracking_links(:one).token}"
    visit "/track/conversions?revenue=199.99"

    login_admin
    click_on "My Site", match: :first
    assert_page_has_content page, tracking_links(:one).token
    assert_page_has_content page, "$199.99"
  end
end
