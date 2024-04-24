class BotthaghosaLauncher < Rails::Railtie
  server do
    puts 'Botthaghosa is running...'
    bot = Botthaghosa.new
    bot.setup_commands
    bot.run_in_background
  end
end
