class Template
  POLL_FINALIZE = <<~TEMPLATE
    ```
    %<sutta_id>s had the most votes, so we will be studying it in our next sutta discussion on %<discussion_date>s.

    Don’t worry if your chosen sutta didn’t make it, we will put up the 2nd and 3rd most voted in the next poll.

    Thanks to everyone that cast their vote. 🙏🙏🙏

    ```
  TEMPLATE
                  .freeze
  NOTIFY_COMMUNITY = <<~TEMPLATE
    ```
    Hey everyone! :wave:

    Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **%<sutta_id>s**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

    Join us on Zoom [here](https://us06web.zoom.us/j/84146622864?pwd=fvhLV0ZF7FxUdXzCWi8JsVOtPh8U7u.1). Hope to see you there for a meaningful and engaging conversation!
    ```
  TEMPLATE
                     .freeze

  TEMPLATE_STRINGS = {
    poll_finalize: POLL_FINALIZE,
    notify_community: NOTIFY_COMMUNITY
  }.freeze

  def initialize(id)
    @template_string = TEMPLATE_STRINGS[id]
  end

  def fill(**args)
    args_with_defaults = args.reverse_merge(default_args)
    @template_string % args_with_defaults if @template_string
  end

  private

  def default_args
    { discussion_date: DiscussionDate.second(:saturday) }
  end
end
