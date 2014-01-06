require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @new_user = User.new
  end

  test "requires first name" do
    @new_user.valid?
    assert_equal ["can't be blank"], @new_user.errors[:first_name]
  end

  test "requires last name" do
    @new_user.valid?
    assert_equal ["can't be blank"], @new_user.errors[:last_name]
  end

  test "requires email address" do
    @new_user.valid?
    assert_equal ["can't be blank"], @new_user.errors[:email]
  end

  test "requires unique email address" do
    @new_user.email = users(:one).email
    @new_user.valid?
    assert_equal ["has already been taken"], @new_user.errors[:email]
  end

  test "requires password" do
    @new_user.valid?
    assert_equal ["can't be blank"], @new_user.errors[:password]
  end

  test "validates password confirmation" do
    @new_user.password = "my-password"
    @new_user.password_confirmation = "non-matching-password"
    @new_user.valid?
    assert_equal ["doesn't match Password"], @new_user.errors[:password_confirmation]
  end

  test "#admin? returns true for admins" do
    users(:one).admin = false
    refute users(:one).admin?, "should return false"
    users(:one).admin = true
    assert users(:one).admin?, "should return true"
  end

  test "#name concatenates first and last" do
    assert_equal "John Smith", users(:one).name
  end

  test "#to_s returns name" do
    assert_equal "John Smith", users(:one).to_s
  end
end
