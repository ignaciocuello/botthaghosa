Bot = Discordrb::Bot.new(
  token: Rails.application.credentials.dig(:discord, :token),
  client_id: Rails.application.credentials.dig(:discord, :app_id),
  intents: [:server_messages]
)

# puts "invite_url: #{Bot.invite_url}"
#
Bot.register_application_command(
  :template,
  'Get template messages',
  server_id: Rails.application.credentials.dig(:discord, :server_id)
) do |cmd|
  cmd.subcommand_group(:poll, 'Get template messages for polls') do |group|
    group.subcommand(:finalize, 'Get template message for finalizing a poll') do |sub|
      sub.string(:sutta_id, 'The ID of the sutta that won the poll', required: true)
    end
  end

  cmd.subcommand_group(:notify, 'Get template messages for notifying') do |group|
    group.subcommand(:community, 'Get template message for notifying the community') do |sub|
      sub.string(:sutta_id, 'The ID of the sutta that we will be discussing', required: true)
    end
  end
end

Bot.application_command(:template).group(:poll) do |group|
  group.subcommand(:finalize) do |event|
    Time.use_zone('Australia/Melbourne') do
      discussion_date = DiscussionDate.second(:saturday)
      sutta_id = event.options['sutta_id']
      template = <<~TEMPLATE
        #{sutta_id} had the most votes, so we will be studying it in our next sutta discussion on #{discussion_date}.

        Don’t worry if your chosen sutta didn’t make it, we will put up the 2nd and 3rd most voted in the next poll.

        Thanks to everyone that cast their vote. 🙏🙏🙏
      TEMPLATE

      event.respond(content: template, ephemeral: true)
    end
  end
end

Bot.application_command(:template).group(:notify) do |group|
  group.subcommand(:community) do |event|
    sutta_id = event.options['sutta_id']
    template = <<~TEMPLATE
      Hey everyone! :wave:

      Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **#{sutta_id}**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

      Join us on Zoom [here](https://us06web.zoom.us/j/84146622864?pwd=fvhLV0ZF7FxUdXzCWi8JsVOtPh8U7u.1). Hope to see you there for a meaningful and engaging conversation!
    TEMPLATE

    event.respond(content: template, ephemeral: true)
  end
end

background = true
Bot.run(background)
