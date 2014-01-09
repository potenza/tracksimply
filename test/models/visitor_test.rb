require 'test_helper'

class VisitorTest < ActiveSupport::TestCase
  test "#name defaults to id if it doesn't exist" do
    visitors(:one).name = nil
    assert_equal visitors(:one).id, visitors(:one).name
  end

  test "#most_recent_visit" do
    visit = Visit.create
    visitors(:one).visits << visit
    assert_equal visit, visitors(:one).most_recent_visit
  end
end
