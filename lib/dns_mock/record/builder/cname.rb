# frozen_string_literal: true

module DnsMock
  module Record
    module Builder
      Cname = ::Class.new(DnsMock::Record::Builder::Base) do
        def build
          [target_factory.new(record_data: records_data).create]
        end
      end
    end
  end
end
