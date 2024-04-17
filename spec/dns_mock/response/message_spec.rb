# frozen_string_literal: true

RSpec.describe DnsMock::Response::Message do
  describe '#as_binary_string' do
    subject(:message_instance) { described_class.new(packet, records, exception_if_not_found) }

    let(:hostname) { random_hostname }
    let(:packet) { create_request_binary_dns_message(hostname, record_type) }
    let(:records) { create_records_dictionary(hostname, record_type) }
    let(:exception_if_not_found) { false }

    DnsMock::AVAILABLE_DNS_RECORD_TYPES.each do |type|
      context "with #{type} dns record type" do
        let(:record_type) { type }

        it "consists collection of #{type} records in dns answer section" do
          records_by_record_type = records.dig(hostname, record_type)
          expect(message_instance.as_binary_string).to have_answer_section_with(hostname, records_by_record_type)
          lookup = message_instance.lookup
          expect(lookup.question[0].to_s).to eq(hostname)
          expect(lookup.question[1].to_s).to match(/\A.+::#{type}/i)
          expect(lookup.answer[0][2]).to eq(records.values[0][type][0])
        end
      end
    end
  end
end
