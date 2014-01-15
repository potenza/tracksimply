class VisitWorker
  include Sidekiq::Worker

  def perform(visit_id)
    Visit.find(visit_id).notify_tracking_link
  end
end
