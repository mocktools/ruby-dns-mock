# frozen_string_literal: true

RSpec.describe DnsMock::Response::Message do
  describe '#as_binary_string' do
    subject(:binary_dns_message) { described_class.new(packet, records).as_binary_string }

    let(:hostname) { random_hostname }
    let(:packet) { create_request_binary_dns_message(hostname, record_type) }
    let(:records) { create_records_dictionary(hostname, record_type) }

    DnsMock::AVAILABLE_DNS_RECORD_TYPES.each do |type|
      context "with #{type} dns record type" do
        let(:record_type) { type }

        it "consists collection of #{type} records in dns answer section" do
          records_by_record_type = records.dig(hostname, record_type)
          expect(binary_dns_message).to have_answer_section_with(hostname, records_by_record_type)
        end
      end
    end
  end
end
