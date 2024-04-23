class Commands
  class << self
    def discussion_set_sutta(abbreviation:, title:)
      session = DiscussionSessionManager.set_sutta_for_this_fortnight(abbreviation:, title:)
      TemplateEngine.generate(:set_sutta)
    end

    def discussion_set_document(link:)
      session = DiscussionSessionManager.set_document_for_this_fortnight(link:)
      TemplateEngine.generate(:set_document)
    end

    def template_poll_finalize(sutta_abbreviation: nil)
      TemplateEngine.generate(:poll_finalize, sutta_abbreviation:)
    end

    def template_notify_community(sutta_abbreviation: nil, sutta_title: nil)
      TemplateEngine.generate(:notify_community, sutta_abbreviation:, sutta_title:)
    end

    def template_document_share(document_link: nil, document_title: nil)
      TemplateEngine.generate(:document_share, document_title:)
    end
  end
end
