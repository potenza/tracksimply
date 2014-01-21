class Visit < ActiveRecord::Base
  belongs_to :site
  belongs_to :visitor
  belongs_to :tracking_link
  has_one :conversion

  after_commit :spawn_worker, on: :create

  def notify_tracking_link
    tracking_link.process_new_visit(self)
  end

  private

  def spawn_worker
    VisitWorker.perform_async(id)
  end
end
