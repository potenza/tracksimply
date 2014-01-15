require "test_helper"

class TrackingLinkWorkerTest < ActiveSupport::TestCase
  test "perform" do
    tracking_link = TrackingLink.new
    tracking_link.expects(:generate_expense_records)
    TrackingLink.expects(:find).with(1).returns(tracking_link)

    TrackingLinkWorker.new.perform(1)
  end

  test "perform_async" do
    assert_difference "TrackingLinkWorker.jobs.size" do
      TrackingLinkWorker.perform_async(1, 1)
    end

    assert_difference "TrackingLinkWorker.jobs.size" do
      tracking_links(:one).dup.save!
    end
  end
end
