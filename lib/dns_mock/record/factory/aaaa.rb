# frozen_string_literal: true

module DnsMock
  module Record
    module Factory
      Aaaa = ::Class.new(DnsMock::Record::Factory::Base) do
        record_type :aaaa

        def instance_params
          record_data
        end
      end
    end
  end
end
