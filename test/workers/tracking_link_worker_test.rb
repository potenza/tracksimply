require "test_helper"

class TrackingLinkWorkerTest < ActiveSupport::TestCase
  test "perform" do
    tracking_link = TrackingLink.new
    tracking_link.expects(:generate_expense_records)
    TrackingLink.expects(:find).with(1).returns(tracking_link)

    TrackingLinkWorker.new.perform(1)
  end
end
