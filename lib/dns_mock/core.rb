# frozen_string_literal: true

module DnsMock
  require_relative '../dns_mock/version'

  RecordTypeError = Class.new(StandardError) do
    def initialize(record_type)
      super("#{record_type} is invalid record type")
    end
  end

  RecordContextError = Class.new(StandardError) do
    def initialize(record_context, record_type)
      super("#{record_context}. Invalid #{record_type} record context")
    end
  end

  RecordContextTypeError = Class.new(StandardError) do
    def initialize(record_context_type, expected_type)
      super("#{record_context_type} is invalid record context type. Should be a #{expected_type}")
    end
  end

  module Record
    module Factory
      require_relative '../dns_mock/record/factory/base'
      require_relative '../dns_mock/record/factory/a'
      require_relative '../dns_mock/record/factory/aaaa'
      require_relative '../dns_mock/record/factory/ns'
      require_relative '../dns_mock/record/factory/mx'
      require_relative '../dns_mock/record/factory/txt'
      require_relative '../dns_mock/record/factory/soa'
      require_relative '../dns_mock/record/factory/cname'
    end
  end
end
