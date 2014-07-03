module RbBigQuery
  class Client
    attr_accessor :client, :project_id, :bq

    # @params opts [Hash] {:application_name, :application_version, :key_path, :service_email, :project_id}
    def initialize(opts = {})
      @client = Google::APIClient.new(
          application_name: opts[:application_name],
          application_version: opts[:application_version]
      )

      key = Google::APIClient::PKCS12.load_key(File.open(
                                                   opts[:key_path], mode: 'rb'),
                                               "notasecret"
      )

      @asserter = Google::APIClient::JWTAsserter.new(
          opts[:service_email],
          "https://www.googleapis.com/auth/bigquery",
          key
      )

      @client.authorization = @asserter.authorize

      @bq = @client.discovered_api("bigquery", "v2")

      @project_id = opts[:project_id]
    end

    # @return [RbBigQuery::Table]
    def find_or_create_table(dataset, table_id, schema)
      RbBigQuery::Table.new(self, dataset, table_id, schema)
    end
  end
end