class DiscussionSession < ApplicationRecord
  has_one :sutta
  has_many :documents
  has_one :session_document, -> { session }, class_name: 'Document'
  has_one :task_document, -> { task }, class_name: 'Document'

  validates :occurs_on, presence: true, uniqueness: true

  # TODO: wrap in transaction
  def set_sutta(abbreviation:, title:)
    sutta.destroy! if sutta.present?
    create_sutta!(abbreviation:, title:)
  end

  def set_session_document(link:)
    session_document.destroy! if session_document.present?
    documents.create!(title: session_document_title, link:, kind: :session)
    reload
  end

  def set_task_document(link:)
    task_document.destroy! if task_document.present?
    documents.create!(title: task_document_title, link:, kind: :task)
    reload
  end

  private

  def session_document_title
    title = occurs_on.strftime('%d-%m-%Y')
    title += " #{sutta.abbreviation}" if sutta.present?
    title
  end

  def task_document_title
    "#{occurs_on.strftime('%d-%m-%y')} - Tasks"
  end
end
