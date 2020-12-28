# frozen_string_literal: true

module DnsMock
  module RecordsDictionaryHelper
    def create_records_dictionary(hostname, *options) # rubocop:disable Metrics/MethodLength)
      DnsMock::RecordsDictionaryBuilder.call(
        {
          hostname.to_s => {
            a: [Faker::Internet.ip_v4_address],
            aaaa: [Faker::Internet.ip_v6_address],
            ns: [random_hostname],
            mx: [random_hostname],
            txt: %w[txt_record_1 txt_record_2],
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

    def hostname_records_by_type(records, hostname, record_type)
      records[hostname.to_s][record_type]
    end
  end
end
