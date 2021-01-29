# frozen_string_literal: true

module DnsMock
  module Response
    class Message
      def initialize(
        packet,
        records,
        exception_if_not_found,
        dns_answer = DnsMock::Response::Answer,
        dns_message = ::Resolv::DNS::Message
      )
        @dns_answer = dns_answer.new(records, exception_if_not_found)
        @dns_message = dns_message.decode(packet)
      end

      def as_binary_string
        @as_binary_string ||= begin
          compose_answer
          dns_message.encode
        end
      end

      private

      attr_reader :dns_answer, :dns_message

      def compose_answer
        dns_message.each_question do |hostname, record_type|
          dns_message.answer.push(*dns_answer.build(hostname, record_type))
        end
      end
    end
  end
end
