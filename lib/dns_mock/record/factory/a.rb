# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      A = Class.new(DnsMock::Record::Factory::Base) do
        record_type :a

        def instance_params
          record_data
        end
      end
    end
  end
end
