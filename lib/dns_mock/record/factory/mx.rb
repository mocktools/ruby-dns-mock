# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Mx = Class.new(DnsMock::Record::Factory::Base) do
        record_type :mx

        def instance_params
          [record_data.first, create_dns_name(record_data.last)]
        end
      end
    end
  end
end
