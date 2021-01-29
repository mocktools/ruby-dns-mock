# frozen_string_literal: true

module DnsMock
  module Response
    class Answer
      TTL = 1
      REVERSE_TYPE_MAPPER = DnsMock::AVAILABLE_DNS_RECORD_TYPES.each_with_object({}) do |record_type, hash|
        hash[::Resolv::DNS::Resource::IN.const_get(record_type.upcase)] = record_type
      end.freeze

      def initialize(records, exception_if_not_found)
        @records = records
        @exception_if_not_found = exception_if_not_found
      end

      def build(hostname, record_class)
        @hostname = hostname
        record_by_type(record_class).map { |record| [hostname, DnsMock::Response::Answer::TTL, record] }
      end

      private

      attr_reader :records, :exception_if_not_found, :hostname

      def record_by_type(record_class)
        record_type = DnsMock::Response::Answer::REVERSE_TYPE_MAPPER[record_class]
        found_records = records.dig(hostname.to_s, record_type)
        raise DnsMock::Error::RecordNotFound.new(record_type, hostname) unless found_records || !exception_if_not_found
        Array(found_records)
      end
    end
  end
end
