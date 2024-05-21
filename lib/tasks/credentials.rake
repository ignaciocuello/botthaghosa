namespace :credentials do
  desc 'Check status of credentials'
  task check: :environment do
    if AuthManager.actually_useful?
      credentials = AuthManager.credentials
      count = GoogleDriveService.new(credentials:).files.size
    else
      DiscordNotifier.pm_debug("Credentials need refreshing: #{Rails.application.routes.url_helpers.authorize_url}")
    end
  end
end
