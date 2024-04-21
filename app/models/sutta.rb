class Sutta < ApplicationRecord
  validates :abbreviation, presence: true, uniqueness: true
end
