# frozen_string_literal: true

RSpec.describe DnsMock::DnsMessageHelper, type: :helper do
  describe '#create_request_binary_dns_message' do
    subject(:request_binary_dns_message) { create_request_binary_dns_message(hostname, record_type) }

    let(:hostname) { random_hostname }

    context 'when valid args' do
      let(:record_type) { random_dns_record_type }

      it 'returns binary dns message with question context in body' do
        expect(request_binary_dns_message).to have_question_section_with(hostname, record_type)
      end
    end

    context 'when invalid args' do
      context 'when invalid record type' do
        let(:record_type) { 42 }

        it do
          expect { request_binary_dns_message }
            .to raise_error(DnsMock::Error::RecordType, "#{record_type} is invalid record type")
        end
      end
    end
  end
end
