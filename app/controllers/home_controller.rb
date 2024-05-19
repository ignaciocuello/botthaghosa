class HomeController < ApplicationController
  def index
    @email = current_admin.email
    credentials = AuthManager.credentials
    @file_count = AuthManager.actually_useful? ? GoogleDriveService.new(credentials:).files.size : 'No connection'
  end
end
