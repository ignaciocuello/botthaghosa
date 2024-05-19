class DiscordNotifier
  class << self
    def send_message(channel_id, content)
      Discordrb::API::Channel.create_message(token, channel_id, content)
    end

    def pm(user_id, content)
      response = Discordrb::API::User.create_pm(token, user_id)
      dm_channel = JSON.parse(response)
      channel_id = dm_channel['id']

      send_message(channel_id, content)
    end

    private

    def token
      "Bot #{Rails.application.credentials.dig(:discord, :token)}"
    end
  end
end
