require_relative 'lib/rbbigquery'
require 'yaml'
require 'pp'

schema = RbBigQuery::Schema.build do
  string :title
  string :body
end

client = RbBigQuery::Client.new YAML.load_file "config/bigquery.yml"

table = client.find_or_create_table("testset", "test5_table", schema)

rows = (1..5).map do |i|
  {
      title: "huga",
      body: "text: #{i}"
  }
end

pp table.insert(rows)

pp client.query("SELECT * from #{table.sql_name}")