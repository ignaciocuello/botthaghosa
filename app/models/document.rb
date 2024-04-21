class Document < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
