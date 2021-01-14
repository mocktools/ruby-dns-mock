# frozen_string_literal: true

module DnsMock
  module Error
    module Helper
      def raise_record_type_error(record_type, condition)
        raise DnsMock::Error::RecordType, record_type unless condition
      end

      def raise_record_context_type_error(record_type, record_context, expected_type)
        current_type, record_type = record_context.class, record_type.upcase
        raise DnsMock::Error::RecordContextType.new(current_type, record_type, expected_type) unless current_type.eql?(expected_type)
      end
    end
  end
end
