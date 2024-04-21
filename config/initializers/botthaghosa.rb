# TODO: Move this to server start, as it's being called on console + migrations
return if true

unless Rails.env.test?
  ActiveSupport::Reloader.to_prepare do
    bot = Botthaghosa.new
    bot.setup_commands
    bot.run
  end
end
