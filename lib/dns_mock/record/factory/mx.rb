# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Mx = Class.new(DnsMock::Record::Factory::Base) do
        record_type :mx

        def instance_params
          [record_data.first, dns_name.create(record_data.last)]
        end
      end
    end
  end
end
