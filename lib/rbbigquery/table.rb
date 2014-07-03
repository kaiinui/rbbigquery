module RbBigQuery
  class Table
    attr_accessor :schema

    def initialize(client, dataset, table_id, schema)
      @client = client
      @dataset = dataset
      @table_id = table_id
      @schema = schema

      create
    end

    # @return row response json
    def create
      response = @client.client.execute({
         :api_method => @client.bq.tables.insert,
         :parameters => {
             'projectId' => @client.project_id,
             'datasetId' => @dataset
         },
         :body_object => {
             'tableReference' => {
                 'projectId' => @client.project_id,
                 'datasetId' => @dataset,
                 'tableId'   => @table_id
             },
             'schema' => {
                 'fields' => @schema
             }
         }
     })

      JSON.parse(response.body)
    end

    # insert rows
    # @param rows [Array<Hash>] [{#{column_name}=>value}]
    # @return row response json
    def insert(rows)
      rows = rows.map do |row|
        {'json' => row}
      end

      response = @client.client.execute({
         :api_method => @client.bq.tabledata.insert_all,
         :parameters => {
             'projectId' => @client.project_id,
             'datasetId' => @dataset,
             'tableId' => @table_id,
         },
         :body_object => {
             "rows" => rows
         }
      })

      JSON.parse(response.body)
    end
  end
end