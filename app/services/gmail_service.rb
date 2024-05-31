class GmailService
  def initialize(credentials:)
    @gmail = Google::Apis::GmailV1::GmailService.new
    @gmail.authorization = credentials
  end

  def send_to_comms(subject:, body:)
    message = RMail::Message.new
    message.header['To'] = Rails.application.credentials[:comms_emails]
    message.header['From'] = 'sutta-group@bsv.net.au'
    message.header['Subject'] = subject
    message.body = body

    @gmail.send_user_message('me',
                             upload_source: StringIO.new(message.to_s),
                             content_type: 'message/rfc822')
  end
end
