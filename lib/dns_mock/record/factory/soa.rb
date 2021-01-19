# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Soa = ::Class.new(DnsMock::Record::Factory::Base) do
        record_type :soa

        def instance_params
          record_data[0..1].map(&method(:create_dns_name)) + record_data[2..-1]
        end
      end
    end
  end
end
