# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Cname = ::Class.new(DnsMock::Record::Factory::Base) do
        record_type :cname

        def instance_params
          [create_dns_name(record_data)]
        end
      end
    end
  end
end
