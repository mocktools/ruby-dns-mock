# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      class Base
        def self.call(target_factory, records_data)
          new(target_factory, records_data).build
        end

        def initialize(target_factory, records_data)
          @target_factory = target_factory
          @records_data = records_data
        end

        def build
          records_data.map { |record_data| target_factory.new(record_data: record_data).create }
        end

        private

        attr_reader :target_factory, :records_data
      end
    end
  end
end
