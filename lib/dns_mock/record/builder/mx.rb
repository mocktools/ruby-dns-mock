# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      class Mx < DnsMock::Record::Builder::Base
        RECORD_PREFERENCE_STEP = 10

        def build
          records_data.map.with_index(1) do |record_data, record_preference|
            target_factory.new(
              record_data: [
                record_preference * DnsMock::Record::Builder::Mx::RECORD_PREFERENCE_STEP,
                record_data
              ]
            ).create
          end
        end
      end
    end
  end
end
