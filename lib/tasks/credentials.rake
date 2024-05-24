namespace :credentials do
  desc 'Check status of credentials'
  task check: :environment do
    credentials = AuthManager.credentials
    count = GoogleDriveService.new(credentials:).files.size
    DiscordNotifier.pm_debug("#{count} files")
    # DiscordNotifier.pm_debug("Credentials need refreshing: #{Rails.application.routes.url_helpers.authorize_url}")
  end
end
