require 'test_helper'

class TrackingLinkTest < ActiveSupport::TestCase
  setup do
    @tracking_link = TrackingLink.new
  end

  test "requires site_id" do
    @tracking_link.valid?
    assert_equal ["can't be blank"], @tracking_link.errors[:site_id]
  end

  test "requires landing_page_url" do
    @tracking_link.valid?
    assert_equal ["can't be blank", "must start with http:// or https://"], @tracking_link.errors[:landing_page_url]
  end

  test "validates landing_page_url protocol" do
    @tracking_link.landing_page_url = "www.google.com"
    @tracking_link.valid?
    assert_equal ["must start with http:// or https://"], @tracking_link.errors[:landing_page_url]
  end

  test "requires campaign" do
    @tracking_link.valid?
    assert_equal ["can't be blank"], @tracking_link.errors[:campaign]
  end

  test "requires source" do
    @tracking_link.valid?
    assert_equal ["can't be blank"], @tracking_link.errors[:source]
  end

  test "requires medium" do
    @tracking_link.valid?
    assert_equal ["can't be blank", "is not included in the list"], @tracking_link.errors[:medium]
  end

  test "validates medium" do
    @tracking_link.medium = "blah blah"
    @tracking_link.valid?
    assert_equal ["is not included in the list"], @tracking_link.errors[:medium]
  end

  test "requires ad_content" do
    @tracking_link.valid?
    assert_equal ["can't be blank"], @tracking_link.errors[:ad_content]
  end

  test "#to_s returns token" do
    assert_equal "053c8581", tracking_links(:one).to_s
  end
end
