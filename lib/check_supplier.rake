require 'httparty'
require 'pry'
require 'nokogiri'

desc "Check if custumer will have water supply"
task :check_water_supply do
  puts "-" * 30
  puts "#{Time.now.strftime("%d/%m/%Y - %H:%M")} - Iniciando a nova verificação de rotina"
  response = HTTParty.post($config["sanasa"]["url"],
  {
    body: { codc: $config["address"]["code"] },
    headers: { 
      'Content-Type' => 'application/x-www-form-urlencoded', 
      'charset' => 'utf-8',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12'
    }
  })

  parsed = Nokogiri::HTML(response.body.strip.gsub(/\t/, '').gsub(/\r/, '').gsub(/\n/, ''))

  endereco  = parsed.css('.content-table .table-form')[0].css('.table-form')[0].text.gsub(/\s+/, " ")
  situacao  = parsed.css('.content-table .table-form')[0].css('.table-form')[1].text.gsub(/\s+/, " ")
  situacao2 = parsed.css('.content-table .table-form')[0].css('.table-form')[2].text.gsub(/\s+/, " ")

  if !situacao.include?("Não existe interrupção")
    #haverá interrupção, notificar os usuários.
    content = endereco + "\n" + situacao + "\n" + situacao2
    mailer_service = Mailer.new(content)
    mailer_service.deliver_mails
    puts "Existe interrupção na data: #{Time.now.strftime("%d/%m/%Y")}"
  end
  puts situacao
  puts "#{Time.now.strftime("%d/%m/%Y - %H:%M")} - Finalizado rotina"
  puts "-" * 30
end