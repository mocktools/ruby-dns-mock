# frozen_string_literal: true

module DnsMock
  module Response
    class Message
      Lookup = Struct.new(:question, :answer)

      def initialize(
        packet,
        records,
        exception_if_not_found,
        dns_answer = DnsMock::Response::Answer,
        dns_message = ::Resolv::DNS::Message
      )
        @dns_answer = dns_answer.new(records, exception_if_not_found)
        @dns_message = dns_message.decode(packet)
        @resolved = nil
      end

      def resolved
        @resolved ||= dns_message.question.map do |hostname, record_type|
          answer = dns_answer.build(hostname, record_type)
          dns_message.answer.push(*answer)

          Lookup.new(question: [hostname, record_type], answer: answer)
        end
      end

      def as_binary_string
        resolved
        dns_message.encode
      end

      private

      attr_reader :dns_answer, :dns_message
    end
  end
end
