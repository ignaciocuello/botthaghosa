class Document < ApplicationRecord
  belongs_to :discussion_session

  validates :title, presence: true, uniqueness: true
end
