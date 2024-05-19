require 'test_helper'

class DiscordNotifierTest < ActiveSupport::TestCase
  test 'send message to channel' do
    channel_id = Rails.application.credentials.dig(:discord, :message_channel_id)
    content = 'Hello there.'
    use_erb_cassette('send api message', erb: { content: }) do
      DiscordNotifier.send_message(channel_id, content)
    end
  end

  test 'send pm to user' do
    user_id = 'RECIPIENT_ID'
    content = 'Hello darkness my old friend.'

    use_erb_cassette('send api pm',  erb: { content: }) do
      DiscordNotifier.pm(user_id, content)
    end
  end
end
