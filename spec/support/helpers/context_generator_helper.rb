# frozen_string_literal: true

module DnsMock
  module ContextGeneratorHelper
    def random_dns_record_type
      DnsMock::AVAILABLE_DNS_RECORD_TYPES.sample
    end

    def random_hostname
      Faker::Internet.domain_name
    end

    def create_dns_name(hostname, dns_name = ::Resolv::DNS::Name)
      dns_name.create("#{hostname}.")
    end

    def random_ip_v4_address
      Faker::Internet.ip_v4_address
    end

    def random_ip_v6_address
      Faker::Internet.ip_v6_address
    end

    def random_txt_record_context
      Faker::Internet.uuid
    end
  end
end
