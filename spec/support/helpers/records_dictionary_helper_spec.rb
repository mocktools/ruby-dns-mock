# frozen_string_literal: true

RSpec.describe DnsMock::RecordsDictionaryHelper, type: :helper do # rubocop:disable RSpec/FilePath
  describe '#create_records_dictionary' do
    subject(:records_dictionary) { create_records_dictionary(hostname, *options) }

    let(:hostname) { Faker::Internet.domain_name }
    let(:options) { [] }

    context 'with Resolv::DNS::Name instance as hostname' do
      let(:hostname) { Resolv::DNS::Name.create(Faker::Internet.domain_name) }

      it 'converts Resolv::DNS::Name instance to string' do
        expect(records_dictionary).to include(hostname.to_s)
      end
    end

    context 'with default options' do
      it 'has hostname as key' do
        expect(records_dictionary).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(records_dictionary[hostname].keys).to include(*DnsMock::AVAILABLE_DNS_RECORD_TYPES)
      end
    end

    context 'with custom options' do
      let(:options) { %i[a aaaa] }

      it 'has hostname as key' do
        expect(records_dictionary).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(records_dictionary[hostname].keys).to include(*options)
      end
    end
  end

  describe '#hostname_records_by_type' do
    let(:hostname) { Faker::Internet.domain_name }
    let(:record_type) { :a }
    let(:records_instances) { %i[a b] }
    let(:records) { { hostname => { record_type => records_instances } } }

    it 'returns array of hostname dns records instances by type' do
      expect(hostname_records_by_type(records, hostname, record_type)).to eq(records_instances)
    end
  end
end
