# frozen_string_literal: true

module DnsMock
  module Error
    module Helper
      def raise_record_context_type_error(record_type, record_context, expected_type)
        current_type, record_type = record_context.class, record_type.upcase
        raise_unless(DnsMock::Error::RecordContextType.new(current_type, record_type, expected_type), current_type.eql?(expected_type))
      end

      def raise_record_type_error(record_type, condition)
        raise_unless(DnsMock::Error::RecordType.new(record_type), condition)
      end

      private

      def raise_unless(error_instance, condition)
        raise error_instance unless condition
      end
    end
  end
end
