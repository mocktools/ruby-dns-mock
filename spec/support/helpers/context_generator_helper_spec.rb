# frozen_string_literal: true

RSpec.describe DnsMock::ContextGeneratorHelper, type: :helper do # rubocop:disable RSpec/FilePath
  describe '#random_dns_record_type' do
    it do
      expect(DnsMock::AVAILABLE_DNS_RECORD_TYPES).to include(random_dns_record_type)
    end
  end

  describe '#random_dns_record_types' do
    it do
      expect(DnsMock::AVAILABLE_DNS_RECORD_TYPES).to include(*random_dns_record_types)
    end
  end

  describe '#random_hostname' do
    it 'returns random hostname' do
      expect(Faker::Internet).to receive(:domain_name).and_call_original
      expect(random_hostname).to be_an_instance_of(::String)
    end
  end

  describe '#create_dns_name' do
    subject(:helper) { create_dns_name(hostname, dns_name) }

    let(:hostname) { random_hostname }
    let(:dns_name) { class_double('DnsName') }
    let(:dns_name_instance) { instance_double('DnsName') }

    it 'returns dns name instance' do
      expect(dns_name).to receive(:create).with("#{hostname}.").and_return(dns_name_instance)
      expect(helper).to eq(dns_name_instance)
    end
  end

  describe '#random_ip_v4_address' do
    subject(:helper) { random_ip_v4_address }

    it 'returns random ipv4 address as String' do
      expect(Faker::Internet).to receive(:ip_v4_address).and_call_original
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#random_ip_v6_address' do
    subject(:helper) { random_ip_v6_address }

    it 'returns random ipv6 address as String' do
      expect(Faker::Internet).to receive(:ip_v6_address).and_call_original
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#random_txt_record_context' do
    subject(:helper) { random_txt_record_context }

    it 'returns random txt record context as String' do
      expect(Faker::Internet).to receive(:uuid).and_call_original
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#create_records_dictionary' do
    subject(:helper) { create_records(hostname, *options) }

    let(:hostname) { random_hostname }
    let(:options) { [] }

    context 'without positional and key words arguments' do
      subject(:helper) { create_records_dictionary }

      it 'returns records dictionary with random hostname and records' do
        expect(described_class).to receive(:random_hostname).and_call_original
        expect(helper).to be_an_instance_of(::Hash)
      end
    end

    context 'with default options' do
      it 'has hostname as key' do
        expect(helper).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(helper[hostname].keys).to include(*DnsMock::AVAILABLE_DNS_RECORD_TYPES)
      end
    end

    context 'with custom options' do
      let(:options) { %i[a aaaa] }

      it 'has hostname as key' do
        expect(helper).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(helper[hostname].keys).to include(*options)
      end
    end
  end

  describe '#random_records' do
    subject(:helper) { random_records }

    it 'returns random valid records for records dictionary builder as Hash' do
      expect(helper).to be_an_instance_of(::Hash)
      records_by_hostname = helper[helper.keys.first]
      expect(records_by_hostname).not_to be_empty
      expect(DnsMock::AVAILABLE_DNS_RECORD_TYPES).to include(*records_by_hostname.keys)
    end
  end

  describe 'random_port_number' do
    subject(:helper) { random_port_number }

    let(:port_number) { 42 }

    it 'returns random port number as Integer' do
      expect(::Random).to receive(:rand).with((49_152..65_535)).and_call_original
      expect(helper).to be_an_instance_of(::Integer)
    end
  end
end
