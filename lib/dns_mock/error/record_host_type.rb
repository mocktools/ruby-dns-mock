# frozen_string_literal: true

module DnsMock
  module Error
    RecordHostType = ::Class.new(::ArgumentError) do
      def initialize(hostname, hostname_class)
        super("Hostname #{hostname} type is #{hostname_class}. Should be a String")
      end
    end
  end
end
