# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      class Srv < DnsMock::Record::Builder::Base
        FACTORY_ARGS_ORDER = %i[priority weight port target].freeze

        def build
          records_data.map do |record_data|
            target_factory.new(
              record_data: record_data.values_at(*DnsMock::Record::Builder::Srv::FACTORY_ARGS_ORDER)
            ).create
          end
        end
      end
    end
  end
end
