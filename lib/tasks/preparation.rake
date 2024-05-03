namespace :preparation do
  desc 'Start preparations for next discussion'
  task start: :environment do
    session = DiscussionSessionManager.session_for_this_fortnight
    session_date = session.occurs_on.strftime('%d-%m-%y')

    CopyTasksTemplateJob.perform_async("2. Private/2024/#{session_date} - Tasks [TEST]")
  end

  task message: :environment do
    bot = Botthaghosa.new
    bot.run_in_background
    bot.send_message('hello')
    bot.stop
  end
end
