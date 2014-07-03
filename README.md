[WIP]rbbigquery
===

A Ruby BigQuery client.

This is a WIP project.
Currently only #insert is available.

```ruby
client = RbBigQuery::Client.new YAML.load_file "config/bigquery.yml"

schema = RbBigQuery::Schema.build do
  string :title
  string :text
end

table = client.find_or_create_table("test_dataset", "test4_table", schema)

rows = (1..5).map do |i|
  {
      screen_name: "title: #{i}",
      text: "text: #{i}"
  }
end

puts table.insert(rows)
```

```
:application_name: YOUR_APPLICATION_NAME
:application_version: YOUR_APPLICATION_VERSION
:key_path: PATH_TO_KEY.p12
:service_email: YOUR_SERVICE_EMAIL
:project_id: YOUR_PROJECT_ID
```