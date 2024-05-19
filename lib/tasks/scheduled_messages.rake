namespace :scheduled_messages do
  desc 'Attempt to send out scheduled messages'
  task attempt: :environment do
    ScheduledMessenger.attempt_send
  end
end
