Gem::Specification.new do |s|
  s.name        = 'popbill'
  s.version     = '1.6.1'
  s.date        = '2018-06-26'
  s.summary     = 'Popbill API SDK'
  s.description = 'Popbill API SDK'
  s.authors     = ["Linkhub Dev"]
  s.email       = 'code@linkhub.co.kr'
  s.files       = [
    "lib/popbill.rb", "lib/popbill/taxinvoice.rb", "lib/popbill/cashbill.rb",
    "lib/popbill/message.rb", "lib/popbill/fax.rb", "lib/popbill/closedown.rb",
    "lib/popbill/htTaxinvoice.rb", "lib/popbill/htCashbill.rb",
    "lib/popbill/statement.rb", "lib/popbill/kakaotalk.rb"
  ]
  s.license     = 'APACHE LICENSE VERSION 2.0'
  s.homepage    = 'https://github.com/linkhub-sdk/popbill.ruby'
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency 'linkhub', '1.1.0'
end
