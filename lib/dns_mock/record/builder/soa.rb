# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      class Soa < DnsMock::Record::Builder::Base
        FACTORY_ARGS_ORDER = %i[mname rname serial refresh retry expire minimum].freeze

        def build
          records_data.map do |record_data|
            target_factory.new(
              record_data: record_data.values_at(*DnsMock::Record::Builder::Soa::FACTORY_ARGS_ORDER)
            ).create
          end
        end
      end
    end
  end
end
