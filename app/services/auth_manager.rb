class AuthManager
  class << self
    def authorizer
      client_id = Google::Auth::ClientId.from_hash(Rails.application.credentials[:google])
      scope = ['https://www.googleapis.com/auth/drive']
      token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
      Google::Auth::WebUserAuthorizer.new(
        client_id, scope, token_store, '/oauth2_callback'
      )
    end

    def credentials
      sutta_group_id = Admin.find_by(email: 'sutta-group@bsv.net.au').id.to_s
      credentials = authorizer.get_credentials(sutta_group_id)
    end

    def actually_useful?
      !useless?
    end

    def useless?
      street_cred = credentials
      street_cred.nil? || street_cred.needs_access_token?
    end
  end
end
