# frozen_string_literal: true

RSpec.describe DnsMock::RspecHelper::RecordsDictionary, type: :helper do
  describe '#create_records_dictionary' do
    subject(:records_dictionary) { create_records_dictionary(hostname, *options) }

    let(:hostname) { random_hostname }
    let(:options) { [] }

    context 'with Resolv::DNS::Name instance as hostname positional argument' do
      let(:hostname) { ::Resolv::DNS::Name.create(random_hostname) }

      it 'converts Resolv::DNS::Name instance to string' do
        expect(records_dictionary).to include(hostname.to_s)
      end
    end

    context 'without positional and key words arguments' do
      subject(:records_dictionary) { create_records_dictionary }

      it 'returns records dictionary with random hostname and records' do
        expect(DnsMock::RspecHelper::ContextGenerator).to receive(:random_hostname).and_call_original
        expect(records_dictionary).to be_an_instance_of(::Hash)
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

  describe '#create_records_dictionary_by_records' do
    subject(:records_dictionary_by_records) { create_records_dictionary_by_records(records) }

    let(:records) { {} }

    it 'returns records dictionary' do
      expect(DnsMock::Server::RecordsDictionaryBuilder).to receive(:call).with(records).and_call_original
      expect(records_dictionary_by_records).to eq(records)
    end
  end

  describe '#hostname_records_by_type' do
    let(:hostname) { random_hostname }
    let(:record_type) { random_dns_record_type }
    let(:records_instances) { %i[a b] }
    let(:records) { { hostname => { record_type => records_instances } } }

    it 'returns array of hostname dns records instances by type' do
      expect(hostname_records_by_type(records, hostname, record_type)).to eq(records_instances)
    end
  end
end
