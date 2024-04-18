class Botthaghosa
  def initialize
    @discord_bot = Discordrb::Bot.new(
      token: Rails.application.credentials.dig(:discord, :token),
      client_id: Rails.application.credentials.dig(:discord, :app_id),
      intents: [:server_messages]
    )
  end

  def setup_commands
    register_commands
    define_commands
  end

  def run
    # puts "invite_url: #{@discord_bot.invite_url}"
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
          sub.string(:sutta_id, 'The ID of the sutta that won the poll', required: true)
        end
      end

      cmd.subcommand_group(:notify, 'Get template messages for notifying') do |group|
        group.subcommand(:community, 'Get template message for notifying the community') do |sub|
          sub.string(:sutta_id, 'The ID of the sutta that we will be discussing', required: true)
        end
      end
    end
  end

  def define_commands
    @discord_bot.application_command(:template).group(:poll) do |group|
      group.subcommand(:finalize) do |event|
        content = Template.new(:poll_finalize).fill(sutta_id: event.options['sutta_id'])
        event.respond(content:, ephemeral: true)
      end
    end

    @discord_bot.application_command(:template).group(:notify) do |group|
      group.subcommand(:community) do |event|
        content = Template.new(:notify_community).fill(sutta_id: event.options['sutta_id'])
        event.respond(content:, ephemeral: true)
      end
    end
  end
end
