require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  test "requires name" do
    site = Site.new
    site.valid?
    assert_equal ["can't be blank"], site.errors[:name]
  end

  test "#to_s outputs name" do
    assert_equal "My Site", sites(:one).to_s
  end
end
