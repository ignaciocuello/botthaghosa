class CopySuttaTemplateJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(destination)
    session_document_file = TemplateDuplicator.copy(template_name: 'DD-MM-YY Sutta-ABBREV', destination:)
    DiscussionSessionManager.session_for_this_fortnight.set_session_document(
      link: session_document_file.web_view_link
    )
  end
end
