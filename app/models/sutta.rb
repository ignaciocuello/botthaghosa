class Sutta < ApplicationRecord
  belongs_to :discussion_session

  validates :abbreviation, presence: true, uniqueness: true

  def full_title
    return abbreviation unless title.present?

    "#{abbreviation} - #{title}"
  end
end
