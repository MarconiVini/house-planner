require 'httparty'
require 'pry'
require 'nokogiri'
require 'sendgrid-ruby'
include SendGrid

desc "Check if custumer will have water supply"
task :check_water_supply do
  response = HTTParty.post(@config["sanasa"]["url"],
  {
      body: { codc: @config["user"]["code"] },
      headers: { 
          'Content-Type' => 'application/x-www-form-urlencoded', 
          'charset' => 'utf-8'
      }
  })
  parsed = Nokogiri::HTML(response.body.strip.gsub(/\t/, '').gsub(/\r/, '').gsub(/\n/, ''))
  
  endereco  = parsed.css('.content-table .table-form')[0].css('.table-form')[0].text.gsub(/\s+/, " ")
  situacao  = parsed.css('.content-table .table-form')[0].css('.table-form')[1].text.gsub(/\s+/, " ")
  situacao2 = parsed.css('.content-table .table-form')[0].css('.table-form')[2].text.gsub(/\s+/, " ")
  
  puts endereco
  
  if situacao.include?("Não existe interrupção")
    puts "Não haverá interupção no servico"
  end

  
  from = Email.new(email: 'cardosounicamp@gmail.com')
  to = Email.new(email: 'cardosounicamp@gmail.com')
  subject = 'Sending with SendGrid is Fun'
  content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
  mail = Mail.new(from, subject, to, content)
  
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  puts response.status_code
  puts response.body
  puts response.headers
end