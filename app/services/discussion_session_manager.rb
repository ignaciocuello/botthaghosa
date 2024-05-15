class DiscussionSessionManager
  class << self
    def session_for_this_fortnight
      session_date = DiscussionSchedule.current(:session_date)
      discussion_session = DiscussionSession.find_or_create_by(occurs_on: session_date)
    end
  end
end
