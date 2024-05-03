class Botthaghosa
  def initialize
    @discord_bot = Discordrb::Bot.new(
      token: Rails.application.credentials.dig(:discord, :token),
      client_id: Rails.application.credentials.dig(:discord, :app_id),
      intents: [:server_messages]
    )
    @discord_bot.ready do |_event|
      @discord_bot.invisible if Rails.env.production?
    end
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

  def send_message(content)
    channel_id = Rails.application.credentials.dig(:discord, :message_channel_id)
    @discord_bot.send_message(channel_id, content)
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
        group.subcommand(:sutta, '1. Set the sutta for the current discussion session') do |sub|
          sub.string(:abbreviation, 'The abbreviation of the sutta (e.g. MN 9)', required: true)
          sub.string(:title, 'The title of the sutta (e.g. Right View)', required: true)
        end
      end

      cmd.subcommand_group(:get, 'Get values for the current discussion session') do |group|
        group.subcommand(:document, 'Get the document link for the current discussion session')
        # TODO: get tasks also
      end

      cmd.subcommand_group(:template, 'Get template messages') do |group|
        group.subcommand(:notify_community,
                         '2. Get template message for notifying the community about the upcoming session')
        group.subcommand(:notify_bsv,
                         '3. Get template message for notifying the BSV communications team about the upcoming session')
        group.subcommand(:share_document,
                         '4. Get template message for sharing the document link')
      end
    end
  end

  def define_commands
    @discord_bot.application_command(:discussion).group(:set) do |group|
      group.subcommand(:sutta) do |event|
        content = Commands.discussion_set_sutta(
          abbreviation: event.options['abbreviation'],
          title: event.options['title']
        )
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:discussion).group(:get) do |group|
      group.subcommand(:document) do |event|
        content = Commands.discussion_get_document
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:discussion).group(:template) do |group|
      group.subcommand(:notify_community) do |event|
        content = Commands.discussion_template_notify_community
        event.respond(content:, ephemeral: true)
      end

      group.subcommand(:notify_bsv) do |event|
        content = Commands.discussion_template_notify_bsv
        event.respond(content:, ephemeral: true)
      end

      group.subcommand(:share_document) do |event|
        content = Commands.discussion_template_document_share
        event.respond(content:, ephemeral: true)
      end
    end
  end

  def server_id
    Rails.application.credentials.dig(:discord, :server_id)
  end
end
