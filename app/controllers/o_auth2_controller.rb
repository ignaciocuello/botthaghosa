class OAuth2Controller < ApplicationController
  before_action :set_authorizer, only: :authorize

  def authorize
    admin_id = current_admin.id.to_s
    credentials = @authorizer.get_credentials(admin_id, request)

    if credentials.present?
      # TODO: use block |resp, err| to not block
      drive = Google::Apis::DriveV3::DriveService.new
      drive.authorization = credentials

      private_folder = drive.list_files(q: "name = '2. Private'").files.first

      year_folders = drive.list_files(q: "name = '2024'", fields: 'files(id, parents)').files
      year_folder = year_folders.find { |f| f.parents.include?(private_folder.id) }
      template_file = drive.list_files(q: "name = 'DD-MM-YY Sutta-ABBREV'").files.first
      copied_file = drive.copy_file(template_file.id, fields: 'id, parents')

      root_id = copied_file.parents.first
      year_id = year_folder.id

      file = Google::Apis::DriveV3::File.new(name: 'Hi!')
      drive.update_file(copied_file.id, file, add_parents: year_id, remove_parents: root_id)
    else
      redirect_to @authorizer.get_authorization_url(login_hint: admin_id, request:),
                  allow_other_host: true
    end
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
