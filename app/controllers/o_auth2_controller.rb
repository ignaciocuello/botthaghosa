class OAuth2Controller < ApplicationController
  def authorize
    @authorizer = AuthManager.authorizer
    admin_id = current_admin.id.to_s
    credentials = @authorizer.get_credentials(admin_id, request)
    return unless credentials.present?

    redirect_to @authorizer.get_authorization_url(login_hint: admin_id, request:),
                allow_other_host: true
  end

  def callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(
      request
    )
    # NOTE: goes to /authorize
    redirect_to target_url
  end
end
