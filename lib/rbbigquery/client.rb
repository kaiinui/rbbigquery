module RbBigQuery
  class Client
    attr_accessor :client, :project_id, :bq

    # @params opts [Hash] {:application_name, :application_version, :key_path, :service_email, :project_id}
    def initialize(opts = {})
      @client = Google::APIClient.new(
          application_name: opts[:application_name],
          application_version: opts[:application_version]
      )
      @bq = @client.discovered_api("bigquery", "v2")
      @project_id = opts[:project_id]
      authorize(opts[:service_email], opts[:key_path])
    end

    # @return [RbBigQuery::Table]
    def find_or_create_table(dataset, table_id, schema)
      RbBigQuery::Table.new(self, dataset, table_id, schema)
    end

    # Executes provided query.
    # @param [String] query
    # @return [String] row response string
    def query(query)
      response = @client.execute({
          :api_method => @bq.jobs.query,
          :parameters => {
              'projectId' => @project_id,
          },
          :body_object => {
              'query' => query
          }
      })

      build_rows_from_response(response)
    end

    private

    def authorize(service_email, key_path)
      key = Google::APIClient::PKCS12.load_key(File.open(key_path, mode: 'rb'), "notasecret")

      asserter = Google::APIClient::JWTAsserter.new(
          service_email,
          "https://www.googleapis.com/auth/bigquery",
          key
      )

      @client.authorization = asserter.authorize
    end

    # Sample response
    #
    #{"kind"=>"bigquery#queryResponse",
    #"schema"=>
    #    {"fields"=>
    #         [{"name"=>"screen_name", "type"=>"STRING", "mode"=>"NULLABLE"},
    #          {"name"=>"text", "type"=>"STRING", "mode"=>"NULLABLE"}]},
    #    "jobReference"=>
    #    {"projectId"=>"#{SOME_PROJECTID}", "jobId"=>"#{SOME_JOBID}"},
    #    "totalRows"=>"15",
    #    "rows"=>
    #    [{"f"=>[{"v"=>"huga"}, {"v"=>"text: 5"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 2"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 4"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 3"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 3"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 1"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 1"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 4"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 2"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 5"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 5"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 3"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 1"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 4"}]},
    #     {"f"=>[{"v"=>"huga"}, {"v"=>"text: 2"}]}],
    #    "totalBytesProcessed"=>"225",
    #    "jobComplete"=>true,
    #    "cacheHit"=>false
    #}
    # @return [Array<Hash>]
    def build_rows_from_response(response)
      return unless response
      body = JSON.parse(response.body)
      schema = body["schema"]["fields"]

      body["rows"].map do |row|
        row_hash = {}
        row["f"].each_with_index do |field, index|
          name = schema[index]["name"]
          row_hash[name] = field["v"]
        end
        row_hash
      end
    end
  end
end