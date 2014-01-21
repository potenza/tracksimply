class ImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    Import.find(import_id).process!
  end
end
