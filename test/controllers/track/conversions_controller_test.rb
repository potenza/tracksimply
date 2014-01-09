require 'test_helper'

class Track::ConversionsControllerTest < ActionController::TestCase
  setup do
    cookies.signed[:v_id] = visitors(:one).id
  end

  test "#index" do
    assert_difference "Conversion.count" do
      get :index, revenue: "4.99"
    end
    assert_equal assigns(:conversion).revenue, 4.99
  end

  test "#index doesn't blowup if visitor not found" do
    cookies.signed[:v_id] = "1234-bad-id"
    assert_nothing_raised do
      get :index, revenue: "4.99"
    end
  end
end
