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
  cmd.subcommand('finalize poll', 'Get template message for finalizing a poll') do |sub|
    sub.string(sutta_id)
  end
end

Bot.message(content: 'Hello') do |event|
  event.respond 'Hello, World!'
end

background = true
Bot.run(background)
