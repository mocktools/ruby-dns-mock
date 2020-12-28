# frozen_string_literal: true

RSpec.describe DnsMock::Response::Answer do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:TTL) }
    it { expect(described_class).to be_const_defined(:REVERSE_TYPE_MAPPER) }
  end

  describe '#build' do
    subject(:dns_answer) { described_class.new(records).build(hostname, record_class) }

    let(:record_type) { :txt }
    let(:records) { create_records_dictionary(hostname, record_type) }
    let(:hostname) { Resolv::DNS::Name.create(Faker::Internet.domain_name) }
    let(:record_class) { Resolv::DNS::Resource::IN::TXT }

    context 'when hostname record found in records dictionary' do
      it 'returns array of arrays with answers' do
        records_by_type = hostname_records_by_type(records, hostname, record_type)
        first_dns_record, second_dns_record = records_by_type
        expect(dns_answer.size).to eq(records_by_type.size)
        expect(dns_answer).to eq(
          [
            [hostname, DnsMock::Response::Answer::TTL, first_dns_record],
            [hostname, DnsMock::Response::Answer::TTL, second_dns_record]
          ]
        )
      end
    end

    context 'when hostname record not found in records dictionary' do
      let(:records) do
        create_records_dictionary(
          Resolv::DNS::Name.create(Faker::Internet.domain_name),
          record_type
        )
      end

      it do
        expect { dns_answer }.to raise_error(
          DnsMock::RecordNotFoundError,
          "#{record_type} not found for #{hostname} in predefined records dictionary"
        )
      end
    end
  end
end
