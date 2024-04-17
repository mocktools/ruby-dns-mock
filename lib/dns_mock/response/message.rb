# frozen_string_literal: true

module DnsMock
  module Response
    class Message
      Lookup = ::Struct.new(:question, :answer, keyword_init: true)

      attr_reader :lookup

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
      attr_writer :lookup

      def compose_answer
        dns_message.each_question do |hostname, record_type|
          self.lookup = DnsMock::Response::Message::Lookup.new(
            question: [hostname, record_type],
            answer: dns_answer.build(hostname, record_type)
          )
          dns_message.answer.push(*lookup.answer)
        end
      end
    end
  end
end
