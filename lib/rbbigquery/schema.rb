module RbBigQuery
  # Schema Builder
  class Schema
    attr_accessor :schema

    class << self
      # Builds schema for BigQuery
      # @param &blk [Proc] RbBigQuery schema DSL
      # @return [Array<Hash>]
      def build(&blk)
        instance = new
        instance.schema = []
        instance.instance_eval &blk
        instance.schema
      end
    end

    def string(name)
      self.schema.push({
        type: 'STRING',
        name: name
      })
    end

    def integer(name)
      self.schema.push({
        type: 'INTEGER',
        name: name
      })
    end
  end
end