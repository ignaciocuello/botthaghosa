class Document < ApplicationRecord
  belongs_to :discussion_session
  enum kind: %i[session task]

  validates :title, presence: true, uniqueness: true
end
