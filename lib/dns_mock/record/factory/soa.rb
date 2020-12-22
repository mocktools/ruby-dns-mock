# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Soa = Class.new(DnsMock::Record::Factory::Base) do
        record_type :soa

        def instance_params
          record_data
        end
      end
    end
  end
end
