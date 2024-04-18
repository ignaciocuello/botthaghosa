ActiveSupport::Reloader.to_prepare do
  bot = Botthaghosa.new
  bot.setup_commands
  bot.run
end
