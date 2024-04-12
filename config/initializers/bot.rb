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
  cmd.subcommand('poll', 'Get template message for finalizing a poll') do |sub|
    sub.string('suttaid', 'The ID of the sutta that won the poll', required: true)
  end
end

# TODO: add date using ice cube
Bot.application_command(:template).subcommand('poll') do |event|
  template = <<~TEMPLATE
    #{event.options['suttaid']} had the most votes, so we will be studying it in our next sutta discussion on {date}.

    Don’t worry if your chosen sutta didn’t make it, we will put up the 2nd and 3rd most voted in the next poll.

    Thanks to everyone that cast their vote. 🙏🙏🙏
  TEMPLATE
  event.respond(content: template, ephemeral: true)
end

background = true
Bot.run(background)
