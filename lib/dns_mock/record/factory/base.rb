# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      class Base
        extend DnsMock::Error::Helper

        class << self
          attr_reader :target_class

          def record_type(record_type)
            @target_class = ::Resolv::DNS::Resource::IN.const_get(
              record_type_check(record_type).upcase
            )
          end

          private

          def record_type_check(defined_record_type)
            raise_record_type_error(defined_record_type, DnsMock::AVAILABLE_DNS_RECORD_TYPES.include?(defined_record_type))
            defined_record_type
          end
        end

        def initialize(
          dns_name = ::Resolv::DNS::Name,
          punycode_representer = DnsMock::Representer::Punycode,
          record_data:
        )
          @dns_name = dns_name
          @punycode_representer = punycode_representer
          @record_data = record_data
        end

        def instance_params; end

        def create
          self.class.target_class.new(*instance_params)
        rescue => error
          raise DnsMock::Error::RecordContext.new(error.message, record_type)
        end

        private

        attr_reader :dns_name, :punycode_representer, :record_data

        def record_type
          self.class.name.split('::').last.upcase
        end

        def create_dns_name(hostname)
          raise ::ArgumentError, "cannot interpret as DNS name: #{hostname}" unless hostname.is_a?(::String)
          dns_name.create("#{punycode_representer.call(hostname)}.")
        end
      end
    end
  end
end
