class UserImportJob < ApplicationJob
  queue_as :default

  def perform
    UserImporter.import_from_spreadsheet
  end
end
