require 'test_helper'

class VisitorTest < ActiveSupport::TestCase
  test "#name defaults to id if it doesn't exist" do
    visitors(:one).name = nil
    assert_equal visitors(:one).id, visitors(:one).name
  end

  test "#most_recent_click" do
    click = Click.create
    visitors(:one).clicks << click
    assert_equal click, visitors(:one).most_recent_click
  end
end
