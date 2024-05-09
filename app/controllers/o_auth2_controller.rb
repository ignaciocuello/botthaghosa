class OAuth2Controller < ApplicationController
  def authorize
    @authorizer = AuthManager.authorizer
    admin_id = current_admin.to_param
    credentials = @authorizer.get_credentials(admin_id, request)
    return unless credentials.nil? || credentials.needs_access_token?

    redirect_to @authorizer.get_authorization_url(login_hint: admin_id, request:),
                allow_other_host: true
  end
end
