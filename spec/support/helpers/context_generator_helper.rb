# frozen_string_literal: true

module DnsMock
  module ContextGeneratorHelper
    def random_dns_record_type
      DnsMock::AVAILABLE_DNS_RECORD_TYPES.sample
    end

    def random_dns_record_types
      DnsMock::AVAILABLE_DNS_RECORD_TYPES.sample(
        rand(1..DnsMock::AVAILABLE_DNS_RECORD_TYPES.size)
      )
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

    def create_records(hostname = DnsMock::ContextGeneratorHelper.random_hostname, *options) # rubocop:disable Metrics/MethodLength)
      {
        hostname => {
          a: [random_ip_v4_address],
          aaaa: [random_ip_v6_address],
          ns: [random_hostname],
          ptr: [random_hostname],
          mx: [random_hostname],
          txt: [random_txt_record_context],
          cname: random_hostname,
          soa: [
            {
              mname: random_hostname,
              rname: random_hostname,
              serial: 2_035_971_683,
              refresh: 10_000,
              retry: 2_400,
              expire: 604_800,
              minimum: 3_600
            }
          ]
        }.slice(*(options.empty? ? DnsMock::AVAILABLE_DNS_RECORD_TYPES : options))
      }
    end

    def random_records
      records = create_records
      hostname = records.keys.first
      { hostname => records[hostname].slice(*random_dns_record_types) }
    end

    module_function

    def random_hostname
      Faker::Internet.domain_name
    end
  end
end
