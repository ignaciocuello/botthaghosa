class TemplateDuplicator
  class << self
    def copy(template_name:, destination:)
      credentials = AuthManager.credentials
      # TODO: let the user know we have not created the file later, rather than failing silently
      return unless credentials.present?

      drive = GoogleDriveService.new(credentials:)
      drive.copy(from: template_name, to: destination)
    end
  end
end
