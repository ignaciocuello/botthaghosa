namespace :preparation do
  desc 'Start preparations for next discussion'
  task start: :environment do
    Commands.discussion_start_preparation
  end
end
