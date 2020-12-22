# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Cname = Class.new(DnsMock::Record::Factory::Base) do
        record_type :cname

        def instance_params
          [dns_name.create(record_data)]
        end
      end
    end
  end
end
