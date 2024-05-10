class GoogleDocsService
  def initialize(credentials:)
    @docs = Google::Apis::DocsV1::DocsService.new
    @docs.authorization = credentials
  end

  def get_text_content(document_id:)
    document = @docs.get_document(document_id)
    text = ''
    document.body.content.each do |structural_element|
      next unless structural_element.paragraph

      structural_element.paragraph.elements.each do |element|
        text += element&.text_run&.content || ''
      end
    end
  end

  def search_and_replace(document_id:, old:, new:)
    contains_text = Google::Apis::DocsV1::SubstringMatchCriteria.new(
      text: old,
      match_case: true
    )
    replace_all_text = Google::Apis::DocsV1::ReplaceAllTextRequest.new(
      contains_text:,
      replace_text: new
    )
    replace_title_request = Google::Apis::DocsV1::Request.new(
      replace_all_text:
    )

    batch_update = Google::Apis::DocsV1::BatchUpdateDocumentRequest.new(
      requests: [replace_title_request]
    )

    @docs.batch_update_document(document_id, batch_update)
  end
end
