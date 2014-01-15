require "test_helper"

class VisitWorkerTest < ActiveSupport::TestCase
  test "perform" do
    visit = Visit.new
    visit.expects(:notify_tracking_link)
    Visit.expects(:find).with(1).returns(visit)

    VisitWorker.new.perform(1)
  end

  test "perform_async" do
    assert_difference "VisitWorker.jobs.size" do
      VisitWorker.perform_async(1, 1)
    end

    assert_difference "VisitWorker.jobs.size" do
      Visit.create
    end
  end
end
