class Sutta < ApplicationRecord
  belongs_to :discussion_session

  validates :abbreviation, presence: true, uniqueness: true
end
