class CopySuttaTemplateJob
  include Sidekiq::Job

  def perform(destination)
    document_session_file = TemplateDuplicator.copy(template_name: 'DD-MM-YY Sutta-ABBREV', destination:)
    DiscussionSessionManager.session_for_this_fortnight.set_document(
      link: document_session_file.web_view_link
    )
  end
end
