class OAuth2Controller < ApplicationController
  before_action :set_authorizer, only: :authorize

  def authorize
    admin_id = current_admin.id.to_s
    credentials = @authorizer.get_credentials(admin_id, request)
    return unless credentials.nil?

    redirect_to @authorizer.get_authorization_url(login_hint: admin_id, request:), allow_other_host: true
  end

  def callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(
      request
    )
    # NOTE: goes to /authorize
    redirect_to target_url
  end

  private

  def set_authorizer
    client_id = Google::Auth::ClientId.from_hash(Rails.application.credentials[:google])
    scope = ['https://www.googleapis.com/auth/drive']
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    @authorizer = Google::Auth::WebUserAuthorizer.new(
      client_id, scope, token_store, '/oauth2_callback'
    )
  end
end
