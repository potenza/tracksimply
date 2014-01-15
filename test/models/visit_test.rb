require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  test "#notify_tracking_link sends a message to tracking link" do
    visit = visits(:one)

    visit.tracking_link.expects(:process_new_visit).with(visit)

    visit.notify_tracking_link
  end
end
