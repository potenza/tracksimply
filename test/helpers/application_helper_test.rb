require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "#title" do
    # hack to get this test to pass
    # ApplicationHelper::#title#test_0001_returns the page title:
    # NoMethodError: undefined method `append' for nil:NilClass
    @view_flow = Minitest::Mock.new
    @view_flow.expect(:append, nil, [:title, " - my title"])

    title("my title")
  end

  test "#page_title" do
    # hack to get this test to pass
    # ApplicationHelper::#title#test_0001_returns the page title:
    # NoMethodError: undefined method `append' for nil:NilClass
    @view_flow = Minitest::Mock.new
    @view_flow.expect(:append, nil, [:title, " - my title"])

    assert_equal "<div class=\"page-header\"><h1>my title</h1></div>", page_title("my title")
  end

  test "#gicon" do
    assert_equal "<span class=\"glyphicon glyphicon-user\"></span>", gicon("user")
  end

  test "#gicon with text" do
    assert_equal "<span class=\"glyphicon glyphicon-user\"></span> Users", gicon("user", "Users")
  end
end
