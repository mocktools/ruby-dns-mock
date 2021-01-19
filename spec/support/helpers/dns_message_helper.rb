# frozen_string_literal: true

module DnsMock
  module DnsMessageHelper
    def create_request_binary_dns_message(hostname, record_type, dns_message = ::Resolv::DNS::Message)
      dns_message.new.tap do |message|
        message.question << [to_dns_name(hostname), dns_record_class_by_type(record_type)]
      end.encode
    end

    private

    def to_dns_name(hostname, dns_name = ::Resolv::DNS::Name)
      dns_name.create("#{hostname}.")
    end

    def dns_record_class_by_type(record_type)
      raise DnsMock::Error::RecordType, record_type unless DnsMock::AVAILABLE_DNS_RECORD_TYPES.include?(record_type)
      ::Resolv::DNS::Resource::IN.const_get(record_type.upcase)
    end
  end
end
