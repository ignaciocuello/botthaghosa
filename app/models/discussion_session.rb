class DiscussionSession < ApplicationRecord
  has_one :sutta
  has_one :document

  validates :occurs_on, presence: true, uniqueness: true

  # TODO: wrap in transaction
  def set_sutta(abbreviation:, title:)
    sutta.destroy! if sutta.present?
    create_sutta!(abbreviation:, title:)
  end

  def set_document(link:)
    document.destroy! if document.present?
    create_document!(title: document_title, link:)
  end

  private

  def document_title
    title = occurs_on.strftime('%d-%m-%y')
    title += " #{sutta.abbreviation}" if sutta.present?
    title
  end
end
