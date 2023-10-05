# frozen_string_literal: true

module DnsMock
  module RspecHelper
    module RecordsDictionary
      def create_records_dictionary(hostname = DnsMock::RspecHelper::ContextGenerator.random_hostname, *options) # rubocop:disable Metrics/MethodLength)
        DnsMock::Server::RecordsDictionaryBuilder.call(
          {
            hostname.to_s => {
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
        )
      end

      def create_records_dictionary_by_records(records)
        DnsMock::Server::RecordsDictionaryBuilder.call(records)
      end

      def hostname_records_by_type(records, hostname, record_type)
        records[hostname.to_s][record_type]
      end
    end
  end
end
