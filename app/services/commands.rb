class Commands
  class << self
    def discussion_set_sutta(abbreviation:, title:)
      DiscussionSessionManager.session_for_this_fortnight.set_sutta(abbreviation:, title:)
      copy_sutta_template
      TemplateEngine.generate(:set_sutta)
    end

    def discussion_get_document
      TemplateEngine.generate(:get_document)
    end

    def discussion_set_document(link:)
      DiscussionSessionManager.session_for_this_fortnight.set_document(link:)
      TemplateEngine.generate(:set_document)
    end

    def discussion_template_notify_community
      TemplateEngine.generate(:notify_community)
    end

    def discussion_template_document_share
      TemplateEngine.generate(:document_share)
    end

    private

    def copy_sutta_template
      credentials = AuthManager.credentials
      # TODO: let the user know we have not created the file later, rather than failing silently
      return unless credentials.present?

      session = DiscussionSessionManager.session_for_this_fortnight
      session_date = session.occurs_on.strftime('%d-%m-%Y')
      sutta_abbreviation = session.sutta.abbreviation

      drive = GoogleDriveService.new(credentials:)
      drive.copy(
        from: 'DD-MM-YY Sutta-ABBREV',
        to: "1. Public/2024/#{session_date} #{sutta_abbreviation}"
      )
    end
  end
end
