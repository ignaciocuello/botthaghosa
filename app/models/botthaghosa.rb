class Botthaghosa
  def initialize(log_mode: :normal)
    @discord_bot = Discordrb::Bot.new(
      log_mode:,
      token: Rails.application.credentials.dig(:discord, :token),
      client_id: Rails.application.credentials.dig(:discord, :app_id),
      intents: [:server_messages]
    )
    @discord_bot.ready do |_event|
      @discord_bot.invisible if Rails.env.production?
    end
    puts @discord_bot.invite_url if Rails.env.production?
  end

  def setup_commands
    clean_commands
    register_commands
    define_commands
  end

  def run_in_background
    background = true
    @discord_bot.run(background)
  end

  def stop
    @discord_bot.stop
  end

  private

  def clean_commands
    commands = @discord_bot.get_application_commands(server_id:)
    commands.each do |command|
      @discord_bot.delete_application_command(command.id, server_id:)
    end
  end

  def register_commands
    @discord_bot.register_application_command(:discussion, 'Commands for sutta discussion', server_id:) do |cmd|
      cmd.subcommand_group(:set, 'Set values for the current discussion session') do |group|
        group.subcommand(:sutta, 'Set the sutta for the current discussion session') do |sub|
          sub.string(:abbreviation, 'The abbreviation of the sutta (e.g. MN 9)', required: true)
          sub.string(:title, 'The title of the sutta (e.g. Right View)', required: true)
        end
      end

      cmd.subcommand_group(:get, 'Get values for the current discussion session') do |group|
        group.subcommand(:session_links, 'Get the links for the current discussion session')
      end
    end
  end

  def define_commands
    @discord_bot.application_command(:discussion).group(:set) do |group|
      group.subcommand(:sutta) do |event|
        content = Commands.discussion_set_sutta(
          abbreviation: event.options['abbreviation'],
          title: event.options['title'],
          logistics_user_id: event.user.id
        )
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:discussion).group(:get) do |group|
      group.subcommand(:session_links) do |event|
        content = Commands.discussion_get_session_links
        event.respond(content:, ephemeral: true)
      end
    end
  end

  def server_id
    Rails.application.credentials.dig(:discord, :server_id)
  end
end
