class GoogleDriveCopyJob
  include Sidekiq::Job

  def perform(from, to)
    credentials = AuthManager.credentials
    # TODO: let the user know we have not created the file later, rather than failing silently
    return unless credentials.present?

    drive = GoogleDriveService.new(credentials:)
    drive.copy(from:, to:)
  end
end
