class CopySuttaTemplateJob
  include Sidekiq::Job

  def perform(to)
    credentials = AuthManager.credentials
    # TODO: let the user know we have not created the file later, rather than failing silently
    return unless credentials.present?

    drive = GoogleDriveService.new(credentials:)
    document_session_file = drive.copy(from: 'DD-MM-YY Sutta-ABBREV', to:)

    DiscussionSessionManager.session_for_this_fortnight.set_document(
      link: document_session_file.web_view_link
    )
  end
end
