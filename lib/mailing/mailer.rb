require 'sendgrid-ruby'
require 'pry'

class Mailer
  include SendGrid

  def initialize(content)
    @content = content
    @separator = ' - '
  end

  def deliver_mails
    $config["users"]["email"].each do |email|
      mail = build_mail(email)
      send(mail)
    end
  end

  private

  def build_mail(email)
    from = Email.new(email: $config['mail_sender'])
    to = Email.new(email: email)
    subject = $config['app_name'] + @separator + Time.now.strftime('%d/%m/%Y') + @separator + $config["mail_subject"]
    content = Content.new(type: 'text/plain', value: @content)
    mail = Mail.new(from, subject, to, content)
  end

  def send(mail)
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end
