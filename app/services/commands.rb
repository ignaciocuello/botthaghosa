class Commands
  class << self
    def discussion_set_sutta(abbreviation:, title:)
      DiscussionSessionManager.session_for_this_fortnight.set_sutta(abbreviation:, title:)
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
  end
end
