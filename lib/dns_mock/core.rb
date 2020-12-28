# frozen_string_literal: true

module DnsMock
  AVAILABLE_DNS_RECORD_TYPES = %i[a aaaa cname mx ns soa txt].freeze

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
    def initialize(record_context_type, record_type, expected_record_context_type)
      super(
        "#{record_context_type} is invalid record context type for " \
        "#{record_type} record. Should be a " \
        "#{expected_record_context_type}"
      )
    end
  end

  RecordNotFoundError = Class.new(StandardError) do
    def initialize(record_type, hostname)
      super("#{record_type} not found for #{hostname} in predefined records dictionary")
    end
  end

  module Helper
    require_relative '../dns_mock/helper/error'
  end

  module Record
    module Factory
      require_relative '../dns_mock/record/factory/base'
      require_relative '../dns_mock/record/factory/a'
      require_relative '../dns_mock/record/factory/aaaa'
      require_relative '../dns_mock/record/factory/cname'
      require_relative '../dns_mock/record/factory/mx'
      require_relative '../dns_mock/record/factory/ns'
      require_relative '../dns_mock/record/factory/soa'
      require_relative '../dns_mock/record/factory/txt'
    end
  end

  module Record
    module Builder
      require_relative '../dns_mock/record/builder/base'
      require_relative '../dns_mock/record/builder/a'
      require_relative '../dns_mock/record/builder/aaaa'
      require_relative '../dns_mock/record/builder/cname'
      require_relative '../dns_mock/record/builder/mx'
      require_relative '../dns_mock/record/builder/ns'
      require_relative '../dns_mock/record/builder/soa'
      require_relative '../dns_mock/record/builder/txt'
    end
  end

  module Response
    require_relative '../dns_mock/response/answer'
  end

  require_relative '../dns_mock/version'
  require_relative '../dns_mock/records_dictionary_builder'
end
