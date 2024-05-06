namespace :preparation do
  desc 'Start preparations for next discussion'
  task start: :environment do
    session = DiscussionSessionManager.session_for_this_fortnight
    first_monday = (session.occurs_on - 12.days).to_date
    if Time.zone.today == first_monday
      Commands.discussion_start_preparation unless session.task_document.present?
    else
      puts "Today is #{Time.zone.today}"
      puts "First monday is #{first_monday}"
    end
  end
end
