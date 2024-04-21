class DiscussionSession < ApplicationRecord
  validates :occurs_on, presence: true, uniqueness: true
end
