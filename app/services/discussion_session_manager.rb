class DiscussionSessionManager
  class << self
    # TODO: wrap in transaction
    def set_sutta_for_this_fortnight(abbreviation:, title:)
      discussion_session = session_for_this_fortnight
      discussion_session.sutta.destroy! if discussion_session.sutta.present?
      discussion_session.create_sutta!(abbreviation:, title:)
      discussion_session
    end

    def session_for_this_fortnight
      next_occurrence = DiscussionScheduler.next_occurrence
      discussion_session = DiscussionSession.find_or_create_by(occurs_on: next_occurrence)
    end
  end
end
