Gem::Specification.new do |s|
  s.name        = 'popbill'
  s.version     = '1.52.0'
  s.date        = '2023-08-09'
  s.summary     = 'Popbill API SDK'
  s.description = 'Popbill API SDK'
  s.authors     = ["Linkhub Dev"]
  s.email       = 'code@linkhubcorp.com'
  s.files       = [
    "lib/popbill.rb", "lib/popbill/taxinvoice.rb", "lib/popbill/cashbill.rb",
    "lib/popbill/message.rb", "lib/popbill/fax.rb", "lib/popbill/closedown.rb","lib/popbill/bizinfocheck.rb",
    "lib/popbill/htTaxinvoice.rb", "lib/popbill/htCashbill.rb",
    "lib/popbill/statement.rb", "lib/popbill/kakaotalk.rb", "lib/popbill/easyFinBank.rb", "lib/popbill/accountCheck.rb"
  ]
  s.license     = 'APACHE LICENSE VERSION 2.0'
  s.homepage    = 'https://github.com/linkhub-sdk/popbill.ruby'
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency 'linkhub', '1.5.0'
end
