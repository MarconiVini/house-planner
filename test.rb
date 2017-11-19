require 'httparty'
require 'pry'
require 'nokogiri'

response = HTTParty.post('http://www.sanasa.com.br/ura-quadrodeavisos/exibeResultado.asp',
{
    body: { codc: '3350063' },
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

binding.pry