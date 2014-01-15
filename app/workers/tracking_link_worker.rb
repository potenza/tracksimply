class TrackingLinkWorker
  include Sidekiq::Worker

  def perform(tracking_link_id)
    TrackingLink.find(tracking_link_id).generate_expense_records
  end
end
