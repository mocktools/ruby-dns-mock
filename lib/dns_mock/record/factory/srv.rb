# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Srv = ::Class.new(DnsMock::Record::Factory::Base) do
        record_type :srv

        def instance_params
          record_data[0..-2] << create_dns_name(record_data.last)
        end
      end
    end
  end
end
