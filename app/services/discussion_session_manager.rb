class DiscussionSessionManager
  class << self
    def session_for_this_fortnight
      next_occurrence = DiscussionScheduler.next_occurrence
      discussion_session = DiscussionSession.find_or_create_by(occurs_on: next_occurrence)
    end
  end
end
