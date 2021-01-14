# frozen_string_literal: true

module DnsMock
  module Error
    RecordContextType = ::Class.new(::ArgumentError) do
      def initialize(record_context_type, record_type, expected_record_context_type)
        super(
          "#{record_context_type} is invalid record context type for " \
          "#{record_type} record. Should be a " \
          "#{expected_record_context_type}"
        )
      end
    end
  end
end
