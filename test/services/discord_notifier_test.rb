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
    user_id = Rails.application.credentials.dig(:discord, :debug_user_id)
    content = 'Hello darkness my old friend.'

    use_erb_cassette('send api pm',  erb: { content:, user_id: }) do
      DiscordNotifier.pm(user_id, content)
    end
  end

  test 'send pm to non debugging user' do
    other_user_id = '1234567890'
    content = 'Hello mate!'

    use_erb_cassette('send api pm non debug',
                     erb: { content:, user_id: other_user_id }) do
      DiscordNotifier.pm(other_user_id, content)
    end
  end
end
