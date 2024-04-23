class TemplateEngine
  # TODO: get these from the DB
  class << self
    POLL_FINALIZE = <<~TEMPLATE
      ```
      %<sutta_id>s had the most votes, so we will be studying it in our next sutta discussion on %<discussion_date>s.

      Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

      Thanks to everyone that cast their vote. 🙏🙏🙏
      ```
    TEMPLATE
                    .freeze
    NOTIFY_COMMUNITY = <<~TEMPLATE
      ```
      Hey everyone! :wave:

      Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **%<sutta_id>s**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

      Join us on Zoom [here](%<session_link>s). Hope to see you there for a meaningful and engaging conversation!
      ```
    TEMPLATE
                       .freeze

    TEMPLATE_STRINGS = {
      poll_finalize: POLL_FINALIZE,
      notify_community: NOTIFY_COMMUNITY
    }.freeze

    def generate(template_name, **args)
      template_string = TEMPLATE_STRINGS[template_name]
      return if template_string.nil?

      args_with_defaults = args.reverse_merge(default_args)
      template_string % args_with_defaults
    end

    private

    def default_args
      # NOTE: this should just use find not find or create
      discussion_session = DiscussionSessionManager.session_for_this_fortnight
      {
        discussion_date: discussion_session.occurs_on.strftime('%B %d'),
        sutta_id: discussion_session.sutta&.abbreviation || '[NO SUTTA SET]',
        session_link: Rails.application.credentials.dig(:zoom, :session_link)
      }
    end
  end
end
