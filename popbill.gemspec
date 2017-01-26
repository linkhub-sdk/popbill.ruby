Gem::Specification.new do |s|
  s.name        = 'popbill'
  s.version     = '1.0.0'
  s.date        = '2017-01-16'
  s.summary     = 'Popbill API SDK'
  s.description = 'Popbill API SDK'
  s.authors     = ["Linkhub Dev"]
  s.email       = 'code@linkhub.co.kr'
  s.files       = [
    "lib/popbill.rb", "lib/taxinvoice.rb", "lib/cashbill.rb", "lib/message.rb",
    "lib/fax.rb", "lib/closedown.rb", "lib/htTxinvoice.rb", "lib/htCashbill.rb",
    "lib.statement.rb"
  ]
  s.license     = 'APACHE LICENSE VERSION 2.0'
  s.homepage    = 'https://github.com/linkhub-sdk/popbill.ruby'
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency 'linkhub', '>=1.0.1'
end
