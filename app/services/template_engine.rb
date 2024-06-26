# TODO: Please refactor this at some point...
class TemplateEngine
  NOTIFY_COMMUNITY = <<~TEMPLATE
    Hello 👋

    Here is a message that you can use to notify the community about the upcoming session in #general (just click on the copy button on the top right):

    ```
    Hey everyone! :wave:

    Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **%<sutta_full_title>s**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

    Join us on Zoom [here](%<zoom_session_link>s). Hope to see you there for a meaningful and engaging conversation!
    ```
  TEMPLATE
                     .freeze

  NOTIFY_BSV = <<~TEMPLATE
    Hey,

    Just posting the link to the sutta discussion document for this Saturday's session. In case you need to update anything on the newsletter.

    %<session_document_link>s

    The Sutta is %<sutta_full_title>s

    Thank you

    Regards,
    Sutta discussion team
  TEMPLATE
               .freeze

  DOCUMENT_SHARE = <<~TEMPLATE
    Hello 👋

    Here is a message that you can use to share the document with everyone in #sutta_discussions (just click on the copy button on the top right):

    ```
    Hey everyone! :wave: Here’s the link to the session document for our upcoming sutta discussion happening this Saturday at 7PM! :clock7:#{' '}

    - [%<sutta_full_title>s](%<session_document_link>s)

    Looking forward to seeing you there!
    ```
  TEMPLATE
                   .freeze

  SET_SUTTA = <<~TEMPLATE
    I have noted the sutta for our next discussion on **%<discussion_date>s** as **"%<sutta_full_title>s"**.

    Here is a message that you can use to notify the community in #announcements (just click on the copy button on the top right):

    ```
    %<sutta_abbreviation>s had the most votes, so we will be studying it in our next sutta discussion on %<discussion_date>s.

    Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

    Thanks to everyone that cast their vote. 🙏🙏🙏
    ```

    I will me messaging you with reminders for tasks in the following days. 🙂
  TEMPLATE
              .freeze

  # TODO: @everyone
  START_PREPARATION = <<~TEMPLATE
    Hello all! 👋

    Here is the task document for the upcoming session on %<discussion_date>s:

    ✅ [%<task_document_title>s](%<task_document_link>s)

    Please put down your name against any role that you would like to do.

    Thank you. 🙏
  TEMPLATE
                      .freeze
  # TODO: @everyone
  PRE_SESSION_LINKS = <<~TEMPLATE
    Hey all. ✌️

    Here is a list of links for the session tonight:

    📖 [%<session_document_title>s](<%<session_document_link>s>)
  
    ✅ [%<task_document_title>s](<%<task_document_link>s>) 

    📝 [Miro Board](<%<miro_link>s>) 

    👉 [Join Zoom Here](<%<zoom_session_link>s>)
   TEMPLATE
                      .freeze

  GET_SESSION_LINKS = <<~TEMPLATE
    Here are some links for the upcoming session:

    📖 [%<session_document_title>s](<%<session_document_link>s>)
  
    ✅ [%<task_document_title>s](<%<task_document_link>s>)  

    📝 [Miro Board](<%<miro_link>s>) 

    💻 <%<zoom_session_link>s>
     TEMPLATE
                      .freeze

  # TODO: get these from the doc
  class << self
    def generate(template_name, **args)
      return unless const_defined?(template_name.to_s.upcase)

      template_string = const_get(template_name.to_s.upcase)

      args_with_defaults = args.reverse_merge(default_args)
      template_string % args_with_defaults
    end

    private

    def default_args
      discussion_session = DiscussionSessionManager.session_for_this_fortnight
      {
        discussion_date: discussion_session.occurs_on.strftime('%B %d'),
        sutta_abbreviation: discussion_session.sutta&.abbreviation || '[NO SUTTA SET]',
        sutta_full_title: discussion_session.sutta&.full_title || '[NO SUTTA SET]',
        session_document_link: discussion_session.session_document&.link || '[NO SESSION DOCUMENT SET]',
        session_document_title: discussion_session.session_document&.title || '[NO SESSION DOCUMENT SET]',
        task_document_link: discussion_session.task_document&.link || '[NO TASK DOCUMENT SET]',
        task_document_title: discussion_session.task_document&.title || '[NO TASK DOCUMENT SET]',
        zoom_session_link: Rails.application.credentials.dig(:zoom, :session_link),
        miro_link: Rails.application.credentials.dig(:miro, :link)
      }
    end
  end
end
