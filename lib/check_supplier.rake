require 'httparty'
require 'pry'
require 'nokogiri'

desc "Check if custumer will have water supply"
task :check_water_supply do
  response = HTTParty.post(@@config["sanasa"]["url"],
  {
    body: { codc: @@config["address"]["code"] },
    headers: { 
      'Content-Type' => 'application/x-www-form-urlencoded', 
      'charset' => 'utf-8'
    }
  })
  parsed = Nokogiri::HTML(response.body.strip.gsub(/\t/, '').gsub(/\r/, '').gsub(/\n/, ''))
  
  endereco  = parsed.css('.content-table .table-form')[0].css('.table-form')[0].text.gsub(/\s+/, " ")
  situacao  = parsed.css('.content-table .table-form')[0].css('.table-form')[1].text.gsub(/\s+/, " ")
  situacao2 = parsed.css('.content-table .table-form')[0].css('.table-form')[2].text.gsub(/\s+/, " ")

  content = endereco + "\n" + situacao + "\n" + situacao2
  mailer_service = Mailer.new(content)
  mailer_service.deliver_mails
  
  # if situacao.include?("Não existe interrupção")
  #   puts "Não haverá interupção no servico"
  # end
end