# frozen_string_literal: true

module DnsMock
  module Error
    RecordNotFound = ::Class.new(::StandardError) do
      def initialize(record_type, hostname)
        super("#{record_type.upcase} record not found for #{hostname} in predefined records dictionary")
      end
    end
  end
end
