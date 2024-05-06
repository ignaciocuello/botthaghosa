namespace :preparation do
  desc 'Start preparations for next discussion'
  task start: :environment do
    first_monday =
      (DiscussionSessionManager.session_for_this_fortnight.occurs_on - 12.days).to_date
    if Time.zone.today == first_monday
      Commands.discussion_start_preparation
    else
      puts "Today is #{Time.zone.today}"
      puts "First monday is #{first_monday}"
    end
  end
end
