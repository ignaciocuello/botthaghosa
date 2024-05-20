namespace :credentials do
  desc 'Check status of credentials'
  task check: :environment do
    if AuthManager.actually_useful?
      credentials = AuthManager.credentials
      GoogleDriveService.new(credentials:).files
    else
      DiscordNotifier.pm_debug("Credentials need refreshing: #{Rails.application.routes.url_helpers.authorize_url}")
    end
  end
end
