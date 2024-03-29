# frozen_string_literal: true

RSpec.describe DnsMock::Response::Answer do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:TTL) }
    it { expect(described_class).to be_const_defined(:REVERSE_TYPE_MAPPER) }
  end

  describe '#build' do
    subject(:dns_answer) do
      described_class.new(records, exception_if_not_found).build(hostname, record_class)
    end

    let(:records) { create_records_dictionary(hostname, record_type) }
    let(:exception_if_not_found) { false }
    let(:hostname) { ::Resolv::DNS::Name.create(random_hostname) }

    context 'when hostname record found in records dictionary' do
      DnsMock::Response::Answer::REVERSE_TYPE_MAPPER.each do |r_class, r_type|
        context "with #{r_type} dns record type" do
          let(:record_class) { r_class }
          let(:record_type) { r_type }

          it 'returns array of arrays with answers' do
            records_by_type = hostname_records_by_type(records, hostname, record_type)
            expect(dns_answer.size).to eq(records_by_type.size)
            expect(dns_answer).to eq(
              ::Array.new(records_by_type.size).map.with_index do |_, index|
                [hostname, DnsMock::Response::Answer::TTL, records_by_type[index]]
              end
            )
          end
        end
      end
    end

    context 'when hostname record not found in records dictionary' do
      context 'when exception strategy disabled' do
        let(:exception_if_not_found) { false }
        let(:record_type) { :a }
        let(:record_class) { ::Resolv::DNS::Resource::IN::A }
        let(:records) { create_records_dictionary(random_hostname, record_type) }

        it { expect(dns_answer).to eq([]) }
      end

      context 'when exception strategy enabled' do
        let(:exception_if_not_found) { true }
        let(:record_type) { :a }
        let(:record_class) { ::Resolv::DNS::Resource::IN::A }
        let(:records) { create_records_dictionary(random_hostname, record_type) }

        it do
          expect { dns_answer }.to raise_error(
            DnsMock::Error::RecordNotFound,
            "#{record_type.upcase} record not found for #{hostname} in predefined records dictionary"
          )
        end
      end
    end
  end
end
