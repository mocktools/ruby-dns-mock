# frozen_string_literal: true

module DnsMock
  class Server
    class RecordsDictionaryBuilder
      include DnsMock::Error::Helper

      IP_ADDRESS_PATTERN = /\A((1\d|[1-9]|2[0-4])?\d|25[0-5])(\.\g<1>){3}\z/.freeze
      TYPE_MAPPER = DnsMock::AVAILABLE_DNS_RECORD_TYPES.zip(
        [
          [DnsMock::Record::Builder::A, DnsMock::Record::Factory::A, ::Array],
          [DnsMock::Record::Builder::Aaaa, DnsMock::Record::Factory::Aaaa, ::Array],
          [DnsMock::Record::Builder::Cname, DnsMock::Record::Factory::Cname, ::String],
          [DnsMock::Record::Builder::Mx, DnsMock::Record::Factory::Mx, ::Array],
          [DnsMock::Record::Builder::Ns, DnsMock::Record::Factory::Ns, ::Array],
          [DnsMock::Record::Builder::Ptr, DnsMock::Record::Factory::Ptr, ::Array],
          [DnsMock::Record::Builder::Soa, DnsMock::Record::Factory::Soa, ::Array],
          [DnsMock::Record::Builder::Txt, DnsMock::Record::Factory::Txt, ::Array]
        ]
      ).to_h.freeze

      def self.call(records_to_build)
        new.build(records_to_build).records
      end

      attr_reader :records

      def initialize(
        punycode_representer = DnsMock::Representer::Punycode,
        rdns_lookup_representer = DnsMock::Representer::RdnsLookup
      )
        @punycode_representer = punycode_representer
        @rdns_lookup_representer = rdns_lookup_representer
        @records = {}
      end

      def build(records_to_build)
        raise_unless(DnsMock::Error::ArgumentType.new(records_to_build.class), records_to_build.is_a?(::Hash))
        records_to_build.each do |hostname, dns_records|
          raise_unless(DnsMock::Error::RecordHostType.new(hostname, hostname.class), hostname.is_a?(::String))
          records[representer(hostname)] = dns_records.each_with_object({}) do |(record_type, records_data), records_instances_by_type|
            records_instances_by_type[record_type] = build_records_instances_by_type(record_type, records_data)
          end
        end

        self
      end

      private

      attr_reader :punycode_representer, :rdns_lookup_representer

      def representer(hostname)
        return rdns_lookup_representer.call(hostname) if hostname[DnsMock::Server::RecordsDictionaryBuilder::IP_ADDRESS_PATTERN]

        punycode_representer.call(hostname)
      end

      def build_records_instances_by_type(record_type, records_to_build)
        target_builder, target_factory, expected_type = DnsMock::Server::RecordsDictionaryBuilder::TYPE_MAPPER[record_type]
        raise_record_type_error(record_type, target_builder)
        raise_record_context_type_error(record_type, records_to_build, expected_type)
        target_builder.call(target_factory, records_to_build)
      end
    end
  end
end
