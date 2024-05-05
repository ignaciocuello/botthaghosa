class Commands
  class << self
    # TODO: change name to CommandsDiscussion.set_sutta, .get_document
    def discussion_start_preparation
      DiscussionSessionManager.session_for_this_fortnight
      copy_task_template
      'On it! 🤖'
    end

    def discussion_set_sutta(abbreviation:, title:)
      DiscussionSessionManager.session_for_this_fortnight.set_sutta(abbreviation:, title:)
      copy_sutta_template
      TemplateEngine.generate(:set_sutta)
    end

    def discussion_get_session_document
      TemplateEngine.generate(:get_session_document)
    end

    def discussion_template_notify_community
      TemplateEngine.generate(:notify_community)
    end

    def discussion_template_notify_bsv
      TemplateEngine.generate(:notify_bsv)
    end

    def discussion_template_document_share
      TemplateEngine.generate(:document_share)
    end

    private

    def copy_task_template
      session = DiscussionSessionManager.session_for_this_fortnight
      session_date = session.occurs_on.strftime('%d-%m-%y')

      CopyTasksTemplateJob.perform_async("2. Private/2024/#{session_date} - Tasks")
    end

    def copy_sutta_template
      session = DiscussionSessionManager.session_for_this_fortnight
      session_date = session.occurs_on.strftime('%d-%m-%Y')
      sutta_abbreviation = session.sutta.abbreviation

      CopySuttaTemplateJob.perform_async("1. Public/2024/#{session_date} #{sutta_abbreviation}")
    end
  end
end
