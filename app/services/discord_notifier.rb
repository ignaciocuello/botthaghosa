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

      # NOTE: should probably be able to toggle this
      pm(debug_user_id, content) unless debug?(user_id)
    end

    private

    def token
      "Bot #{Rails.application.credentials.dig(:discord, :token)}"
    end

    def debug_user_id
      Rails.application.credentials.dig(:discord, :debug_user_id)
    end

    # TODO: add a failing test for this
    def debug?(user_id)
      user_id.to_s == debug_user_id.to_s
    end
  end
end
