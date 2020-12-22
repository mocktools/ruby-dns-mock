# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Ns = Class.new(DnsMock::Record::Factory::Base) do
        record_type :ns

        def instance_params
          [dns_name.create(record_data)]
        end
      end
    end
  end
end
