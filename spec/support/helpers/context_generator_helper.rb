# frozen_string_literal: true

module DnsMock
  module ContextGeneratorHelper
    NON_ASCII_WORDS = %w[mañana ĉapelo dấu παράδειγμα 屋企].freeze

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
      ffaker.ip_v4_address
    end

    def random_ip_v6_address
      "2001:db8:#{%w[11a3 9d7 1f34 8a2e 7a0 765d].shuffle.join(':')}"
    end

    def random_txt_record_context
      ::SecureRandom.uuid
    end

    def random_non_ascii_hostname
      "#{DnsMock::ContextGeneratorHelper::NON_ASCII_WORDS.sample}#{random_hostname}"
    end

    def random_hostname_by_ascii(hostname)
      hostname.ascii_only? ? random_hostname : random_non_ascii_hostname
    end

    def create_records(hostname = DnsMock::ContextGeneratorHelper.random_hostname, *records, **options) # rubocop:disable Metrics/MethodLength)
      return { hostname => options } unless options.empty?

      {
        hostname => {
          a: [random_ip_v4_address],
          aaaa: [random_ip_v6_address],
          ns: [random_hostname_by_ascii(hostname)],
          ptr: [random_hostname_by_ascii(hostname)],
          mx: [random_hostname_by_ascii(hostname)],
          txt: [random_txt_record_context],
          cname: random_hostname_by_ascii(hostname),
          soa: [
            {
              mname: random_hostname_by_ascii(hostname),
              rname: random_hostname_by_ascii(hostname),
              serial: 2_035_971_683,
              refresh: 10_000,
              retry: 2_400,
              expire: 604_800,
              minimum: 3_600
            }
          ]
        }.slice(*(records.empty? ? DnsMock::AVAILABLE_DNS_RECORD_TYPES : records))
      }
    end

    def random_records
      records = create_records
      hostname = records.keys.first
      { hostname => records[hostname].slice(*random_dns_record_types) }
    end

    def random_port_number
      ::Random.rand(49_152..65_535)
    end

    def to_rdns_hostaddress(ip_address)
      DnsMock::Representer::RdnsLookup.call(ip_address)
    end

    def to_punycode_hostname(hostname)
      SimpleIDN.to_ascii(hostname)
    end

    module_function

    def ffaker
      FFaker::Internet
    end

    def random_hostname
      ffaker.domain_name
    end
  end
end
