class Commands
  class << self
    def discussion_set_sutta(abbreviation:, title:)
      session = DiscussionSessionManager.set_sutta_for_this_fortnight(abbreviation:, title:)
      TemplateEngine.generate(:set_sutta)
    end

    def discussion_set_document(title:, link:); end

    def template_poll_finalize(sutta_abbreviation: nil); end

    def template_notify_community(sutta_abbreviation: nil, sutta_title: nil); end

    def template_notify_bsv(document_link: nil, sutta_abbreviation: nil); end

    def template_document_share(document_link: nil, sutta_abbreviation: nil, sutta_title: nil); end
  end
end
