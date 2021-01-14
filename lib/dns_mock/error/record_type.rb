# frozen_string_literal: true

module DnsMock
  module Error
    RecordType = ::Class.new(::StandardError) do
      def initialize(record_type)
        super("#{record_type} is invalid record type")
      end
    end
  end
end
