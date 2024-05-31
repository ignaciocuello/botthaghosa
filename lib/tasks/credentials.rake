namespace :credentials do
  desc 'Check status of credentials'
  task check: :environment do
    credentials = AuthManager.credentials
    count = GoogleDriveService.new(credentials:).files.size
    puts "#{count} files"
  rescue Signet::AuthorizationError
    DiscordNotifier.pm_debug("Credentials need refreshing: #{Rails.application.routes.url_helpers.authorize_url}")
  end
end
