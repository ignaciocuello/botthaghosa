class DiscussionSessionManager
  class << self
    # TODO: wrap in transaction
    # TODO: some of these should be in discussion_session
    def set_sutta_for_this_fortnight(abbreviation:, title:)
      discussion_session = session_for_this_fortnight
      discussion_session.sutta.destroy! if discussion_session.sutta.present?
      discussion_session.create_sutta!(abbreviation:, title:)
      discussion_session
    end

    # TODO: wrap in transaction
    def set_document_for_this_fortnight(link:)
      discussion_session = session_for_this_fortnight
      discussion_session.document.destroy! if discussion_session.document.present?
      title = discussion_session.occurs_on.strftime('%d-%m-%y')
      title += " #{discussion_session.sutta.abbreviation}" if discussion_session.sutta.present?
      discussion_session.create_document!(title:, link:)
      discussion_session
    end

    def session_for_this_fortnight
      next_occurrence = DiscussionScheduler.next_occurrence
      discussion_session = DiscussionSession.find_or_create_by(occurs_on: next_occurrence)
    end
  end
end