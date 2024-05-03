namespace :preparation do
  desc 'Start preparations for next discussion'
  task start: :environment do
    session = DiscussionSessionManager.session_for_this_fortnight
    session_date = session.occurs_on.strftime('%d-%m-%y')

    CopyTasksTemplateJob.perform_async("2. Private/2024/#{session_date} - Tasks [TEST]")
  end
end
