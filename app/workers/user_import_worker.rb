class UserImportWorker
  include Sidekiq::Worker

  def perform
    UserImporter.import_from_spreadsheet
  end
end