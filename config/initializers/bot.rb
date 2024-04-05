Bot = Discordrb::Commands::CommandBot.new(
  token: Rails.application.credentials.dig(:discord, :token),
  client_id: Rails.application.credentials.dig(:discord, :app_id),
  prefix: '/'
)

puts "invite_url: #{Bot.invite_url}"

Bot.message(content: 'Hello') do |event|
  event.respond 'Hello, World!'
end

background = true
Bot.run(background)
