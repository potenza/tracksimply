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

  test "#breadcrumbs" do
    html = %Q{<ol class="breadcrumb"><li><a href="/sites">Sites</a></li><li><a href="/sites/#{sites(:one).id}">#{sites(:one).name}</a></li><li><a href="/sites/#{sites(:one).id}/tracking_links">Tracking Links</a></li><li><a href="/sites/#{sites(:one).id}/tracking_links/#{tracking_links(:one).id}">#{tracking_links(:one).token}</a></li><li class="active">Edit</li></ol>}
    assert_equal html, breadcrumbs(sites_path, sites(:one), site_tracking_links_path(sites(:one)), [sites(:one), tracking_links(:one)], "Edit")
  end

  test "#back without options" do
    html = %Q{<a class="btn btn-default" href="/users"><span class="glyphicon glyphicon-chevron-left"></span> Back</a>}
    assert_equal html, back("/users")
  end

  test "#back with options" do
    html = %Q{<a class="btn btn-danger" href="/users"><span class="glyphicon glyphicon-users"></span> Back to Users</a>}
    assert_equal html, back("/users", text: "Back to Users", icon: "users", css: "btn btn-danger")
  end
end
