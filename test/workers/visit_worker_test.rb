require "test_helper"

class VisitWorkerTest < ActiveSupport::TestCase
  test "perform" do
    visit = Visit.new
    visit.expects(:notify_tracking_link)
    Visit.expects(:find).with(1).returns(visit)

    VisitWorker.new.perform(1)
  end
end
