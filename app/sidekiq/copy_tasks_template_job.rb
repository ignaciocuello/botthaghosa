class CopyTasksTemplateJob
  include Sidekiq::Job

  def perform(destination)
    TemplateDuplicator.copy(template_name: 'DD-MM-YY - Tasks', destination:)
  end
end
