require "test_helper"

class ImportWorkerTest < ActiveSupport::TestCase
  test "perform" do
    import = Import.new
    import.expects(:process!)
    Import.expects(:find).with(1).returns(import)

    ImportWorker.new.perform(1)
  end
end
