namespace :credentials do
  desc 'Check status of credentials'
  task check: :environment do
    credentials = AuthManager.credentials
    count = GoogleDriveService.new(credentials:).files.size
    begin
      puts "#{count} files"
    rescue StandardError
      DiscordNotifier.pm_debug("Credentials need refreshing: #{Rails.application.routes.url_helpers.authorize_url}")
    end
  end
end
