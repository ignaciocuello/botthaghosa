class ScheduledMessenger
  class << self
    def attempt_send
      return start_preparation if DiscussionSchedule.current?(:first_monday)
      return notify if DiscussionSchedule.current?(:second_monday)
      return share if DiscussionSchedule.current?(:second_wednesday)

      false
    end

    private

    def start_preparation
      session = DiscussionSessionManager.session_for_this_fortnight
      return if session.task_document.present?

      Commands.discussion_start_preparation
      true
    end

    def notify
      notify_community = TemplateEngine.generate(:notify_community)
      DiscordNotifier.pm(logistics_user_id, notify_community)

      GmailService.new(credentials: AuthManager.credentials)
                  .send_to_comms(
                    subject: 'Sutta discussion details for next session',
                    body: TemplateEngine.generate(:notify_bsv)
                  )
      true
    end

    def share
      document_share = TemplateEngine.generate(:document_share)
      DiscordNotifier.pm(logistics_user_id, document_share)
      true
    end

    def logistics_user_id
      session = DiscussionSessionManager.session_for_this_fortnight
      session.logistics_user_id
    end
  end
end
