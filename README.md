[WIP]rbbigquery
===

[![Gem Version](https://badge.fury.io/rb/rbbigquery.svg)](http://badge.fury.io/rb/rbbigquery)

A Ruby BigQuery client.

**This is a WIP project. Currently only #insert is available.**

```ruby
client = RbBigQuery::Client.new YAML.load_file "config/bigquery.yml"

schema = RbBigQuery::Schema.build do
  string :title
  string :text
end

table = client.find_or_create_table("test_dataset", "test4_table", schema)

rows = (1..5).map do |i|
  {
      title: "title: #{i}",
      text: "text: #{i}"
  }
end

puts table.insert(rows)
```

then touch `config/bigquery.yml` as following where auhentication info are available at Google Developer console -> APIs & AUTH -> Credentials.
```ruby
:application_name: YOUR_APPLICATION_NAME # You can set any name. (e.g. 'myapplication')
:application_version: YOUR_APPLICATION_VERSION # You can set any version. (e.g. '0.1')
:key_path: PATH_TO_KEY.p12 # find in Google dashboard
:service_email: YOUR_SERVICE_EMAIL # find in Google dashboard
:project_id: YOUR_PROJECT_ID # find in Google dashboard
```

Where can I get my keys?
---

You can find `:key_path` and `:service_email` as following.

![](https://raw.githubusercontent.com/kaiinui/rbbigquery/master/rbbigquery-apidesc.png)

You can find `project_id` in top page of the dashboard(which PROJECT are listed). See column 'PROJECT ID'.

TODO
---

1. Write tests. (**There's no test now. Be careful.**)

Licence
---

Copyright (c) 2013 Kai Inui, Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
