Gem::Specification.new do |s|
  s.name        = 'rbbigquery'
  s.version     = '0.0.1'
  s.date        = '2014-07-03'
  s.summary     = "[WIP] Ruby BigQuery client."
  s.description = "[WIP ]Provides a easier way to handle BigQuery with Ruby."
  s.authors     = ["Kai Inui"]
  s.email       = 'me@kaiinui.com'
  s.files       = ["lib/rbbigquery.rb", "lib/rbbigquery/client.rb", "lib/rbbigquery/table.rb", "lib/rbbigquery/schema.rb"]
  s.add_runtime_dependency "google-api-client"
  s.homepage    = 'https://github.com/kaiinui/rbbigquery'
  s.license     = 'MIT'
end