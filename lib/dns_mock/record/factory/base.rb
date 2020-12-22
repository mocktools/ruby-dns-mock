# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      class Base
        require 'resolv'

        DNS_RECORD_TYPES = %i[a aaaa cname mx ns soa txt].freeze

        class << self
          attr_reader :target_class

          def record_type(record_type)
            @target_class = Resolv::DNS::Resource::IN.const_get(
              record_type_check(record_type).upcase
            )
          end

          private

          def record_type_check(defined_record_type)
            valid_record_type = DnsMock::Record::Factory::Base::DNS_RECORD_TYPES.include?(defined_record_type)
            raise DnsMock::RecordTypeError, defined_record_type unless valid_record_type
            defined_record_type
          end
        end

        def initialize(dns_name = Resolv::DNS::Name, record_data:)
          @dns_name = dns_name
          @record_data = record_data
        end

        def instance_params; end

        def create
          self.class.target_class.public_send(:new, *instance_params)
        rescue => error
          raise DnsMock::RecordContextError.new(error.message, record_type)
        end

        private

        attr_reader :dns_name, :record_data

        def record_type
          self.class.name.split('::').last.upcase
        end
      end
    end
  end
end