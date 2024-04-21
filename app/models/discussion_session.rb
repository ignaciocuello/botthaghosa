class DiscussionSession < ApplicationRecord
  has_one :sutta
  has_one :document

  validates :occurs_on, presence: true, uniqueness: true
end
