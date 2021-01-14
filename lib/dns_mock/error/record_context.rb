# frozen_string_literal: true

module DnsMock
  module Error
    RecordContext = ::Class.new(::StandardError) do
      def initialize(record_context, record_type)
        super("#{record_context}. Invalid #{record_type} record context")
      end
    end
  end
end
