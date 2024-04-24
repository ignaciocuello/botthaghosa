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
    @discord_bot.register_application_command(
      :template,
      'Get template messages',
      server_id: Rails.application.credentials.dig(:discord, :server_id)
    ) do |cmd|
      cmd.subcommand_group(:poll, 'Get template messages for polls') do |group|
        group.subcommand(:finalize, 'Get template message for finalizing a poll') do |sub|
          sub.string(:sutta_id, 'The ID of the sutta that won the poll', required: false)
        end
      end

      cmd.subcommand_group(:notify, 'Get template messages for notifying') do |group|
        group.subcommand(:community, 'Get template message for notifying the community') do |sub|
          sub.string(:sutta_id, 'The ID of the sutta that we will be discussing', required: false)
          sub.string(:sutta_title, 'The ID of the sutta that we will be discussing', required: false)
        end
      end

      cmd.subcommand_group(:document, 'Get template messages for documents') do |group|
        group.subcommand(:share, 'Get template message for sharing a document') do |sub|
          sub.string(:document_link, 'The link to the document', required: false)
        end
      end
    end

    @discord_bot.register_application_command(:session, 'Interact with the current discussion session') do |cmd|
      cmd.subcommand_group(:sutta, 'Interact with the session sutta') do |group|
        group.subcommand(:set, 'Set the sutta for the current discussion session') do |sub|
          sub.string(:id, 'The abbreviation of the sutta', required: true)
          sub.string(:title, 'The title of the sutta', required: false)
        end
      end

      cmd.subcommand_group(:document, 'Set values for the current discussion session') do |group|
        group.subcommand(:set, 'Interact witht the session sutta') do |sub|
          sub.string(:link, 'Set the link for the current discussion session', required: true)
        end
      end
    end
  end

  def define_commands
    @discord_bot.application_command(:template).group(:poll) do |group|
      group.subcommand(:finalize) do |event|
        content = Commands.template_poll_finalize(sutta_abbreviation: event.options['sutta_id'])
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:template).group(:notify) do |group|
      group.subcommand(:community) do |event|
        content = Commands.template_notify_community(sutta_abbreviation: event.options['sutta_id'],
                                                     sutta_title: event.options['sutta_title'])
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:template).group(:document) do |group|
      group.subcommand(:share) do |event|
        content = Commands.template_document_share(document_link: event.options['document_link'])

        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:session).group(:sutta) do |group|
      group.subcommand(:set) do |event|
        content = Commands.discussion_set_sutta(abbreviation: event.options['id'], title: event.options['title'])
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:session).group(:document) do |group|
      group.subcommand(:set) do |event|
        content = Commands.discussion_set_document(link: event.options['link'])
        event.respond(content:, ephemeral: true)
      end
    end
  end
end
