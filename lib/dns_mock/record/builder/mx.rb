# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      class Mx < DnsMock::Record::Builder::Base
        include DnsMock::Error::Helper

        MX_RECORD_REGEX_PATTERN = /\A(.+):(\d+)|(.+)\z/.freeze
        RECORD_PREFERENCE_STEP = 10

        def build
          records_data.map.with_index(1) do |record_data, record_preference|
            record_data, custom_record_preference = parse_mx_record_data(record_data)
            target_factory.new(
              record_data: [
                custom_record_preference&.to_i || (record_preference * DnsMock::Record::Builder::Mx::RECORD_PREFERENCE_STEP),
                record_data
              ]
            ).create
          end
        end

        private

        def parse_mx_record_data(record_data)
          raise_record_context_type_error(:mx, record_data, ::String)
          record_data.scan(DnsMock::Record::Builder::Mx::MX_RECORD_REGEX_PATTERN).flatten.compact
        end
      end
    end
  end
end
