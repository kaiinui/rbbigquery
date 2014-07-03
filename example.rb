require_relative 'lib/rbbigquery'
require 'yaml'

schema = RbBigQuery::Schema.build do
  string :screen_name
  string :text
end

client = RbBigQuery::Client.new YAML.load_file "config/bigquery.yml"

table = client.find_or_create_table("testset", "test4_table", schema)

rows = (1..5).map do |i|
  {
      screen_name: "huga",
      text: "text: #{i}"
  }
end

puts table.insert(rows)