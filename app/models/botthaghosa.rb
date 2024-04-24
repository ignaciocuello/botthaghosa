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
    register_commands
    define_commands
  end

  def run_in_background
    background = true
    @discord_bot.run(background)
  end

  private

  def register_commands
    @discord_bot.register_application_command(:discussion, 'Commands for sutta discussion', server_id:) do |cmd|
      cmd.subcommand_group(:set, 'Set values for the current discussion session') do |group|
        group.subcommand(:sutta, 'Set the sutta for the current discussion session') do |sub|
          sub.string(:abbreviation, 'The abbreviation of the sutta (e.g. MN 9)', required: true)
          sub.string(:title, 'The title of the sutta (e.g. Right View)', required: true)
        end

        group.subcommand(:document, 'Set the document link for the current discussion session') do |sub|
          sub.string(:link, 'The link to the session document', required: true)
        end
      end

      cmd.subcommand_group(:template, 'Get template messages') do |group|
        group.subcommand(:notify_community,
                         'Get template message for notifying the community about the upcoming session')
        group.subcommand(:share_document,
                         'Get template message for sharing the document link')
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

      group.subcommand(:document) do |event|
        content = Commands.discussion_set_document(link: event.options['link'])
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:discussion).group(:template) do |group|
      group.subcommand(:notify_community) do |event|
        content = Commands.discussion_template_notify_community
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
