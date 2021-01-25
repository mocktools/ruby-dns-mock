# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Ptr = ::Class.new(DnsMock::Record::Factory::Base) do
        record_type :ptr

        def instance_params
          [create_dns_name(record_data)]
        end
      end
    end
  end
end
