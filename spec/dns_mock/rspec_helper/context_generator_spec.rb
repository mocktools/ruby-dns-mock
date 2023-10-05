# frozen_string_literal: true

RSpec.describe DnsMock::RspecHelper::ContextGenerator, type: :helper do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:NON_ASCII_WORDS) }
  end

  describe 'DnsMock::ContextGeneratorHelper::NON_ASCII_WORDS' do
    it do
      expect(described_class::NON_ASCII_WORDS.none?(:ascii_only?)).to be(true)
    end
  end

  describe '.ffaker' do
    it do
      expect(described_class.ffaker).to eq(FFaker::Internet)
    end
  end

  describe '.random_hostname' do
    it 'returns random hostname' do
      expect(FFaker::Internet).to receive(:domain_name).and_call_original
      expect(described_class.random_hostname).to be_an_instance_of(::String)
    end
  end

  describe '#ffaker' do
    it do
      expect(ffaker).to eq(FFaker::Internet)
    end
  end

  describe '#random_hostname' do
    it 'returns random hostname' do
      expect(FFaker::Internet).to receive(:domain_name).and_call_original
      expect(random_hostname).to be_an_instance_of(::String)
    end
  end

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
      expect(FFaker::Internet).to receive(:ip_v4_address).and_call_original
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#random_ip_v6_address' do
    subject(:helper) { random_ip_v6_address }

    it 'returns random ipv6 address as String' do
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#random_txt_record_context' do
    subject(:helper) { random_txt_record_context }

    it 'returns random txt record context as String' do
      expect(::SecureRandom).to receive(:uuid).and_call_original
      expect(helper).to be_an_instance_of(::String)
    end
  end

  describe '#create_records_dictionary' do
    subject(:helper) { create_records(hostname, *records, **options) }

    let(:hostname) { random_hostname }
    let(:records) { [] }
    let(:options) { {} }

    context 'without positional, records and key words arguments' do
      subject(:helper) { create_records_dictionary }

      it 'returns records dictionary with random hostname and records' do
        expect(described_class).to receive(:random_hostname).and_call_original
        expect(helper).to be_an_instance_of(::Hash)
      end
    end

    context 'with default records' do
      it 'has hostname as key' do
        expect(helper).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(helper[hostname].keys).to include(*DnsMock::AVAILABLE_DNS_RECORD_TYPES)
      end
    end

    context 'with custom records' do
      let(:records) { %i[a aaaa] }

      it 'has hostname as key' do
        expect(helper).to include(hostname)
      end

      it 'has DnsMock::AVAILABLE_DNS_RECORD_TYPES as nested key values' do
        expect(helper[hostname].keys).to include(*options)
      end
    end

    context 'with key words arguments' do
      let(:options) { { a: 1 } }

      it 'returns custom records by hostname key' do
        expect(helper).to eq(hostname => options)
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

  describe '#random_port_number' do
    subject(:helper) { random_port_number }

    let(:port_number) { 42 }

    it 'returns random port number as Integer' do
      expect(::Random).to receive(:rand).with((49_152..65_535)).and_call_original
      expect(helper).to be_an_instance_of(::Integer)
    end
  end

  describe '#random_non_ascii_hostname' do
    it 'returns hostname with non ASCII chars' do
      stub_const('DnsMock::ContextGeneratorHelper::NON_ASCII_WORDS', ['ĉapelo.org'])
      expect(FFaker::Internet).to receive(:domain_suffix).and_call_original
      expect(random_non_ascii_hostname.ascii_only?).to be(false)
    end
  end

  describe '#to_punycode_hostname' do
    subject(:helper) { to_punycode_hostname(hostname) }

    let(:hostname) { '買.屋企' }

    it 'returns ASCII hostname with backslashes' do
      expect(SimpleIDN).to receive(:to_ascii).with(hostname).and_call_original
      expect(helper.ascii_only?).to be(true)
      expect(helper).to eq('xn--uk3a.xn--hoqu73a')
    end
  end

  describe '#random_hostname_by_ascii' do
    context 'when ASCII hostname' do
      let(:hostname) { random_hostname }

      it 'returns new ASCII random hostname' do
        result = random_hostname_by_ascii(hostname)
        expect(result.ascii_only?).to be(true)
        expect(result).not_to eq(hostname)
      end
    end

    context 'when not ASCII hostname' do
      let(:hostname) { random_non_ascii_hostname }

      it 'returns new random not ASCII hostname' do
        result = random_hostname_by_ascii(hostname)
        expect(result.ascii_only?).to be(false)
        expect(result).not_to eq(hostname)
      end
    end
  end

  describe '#to_rdns_hostaddress' do
    it do
      expect(DnsMock::Representer::RdnsLookup).to receive(:call).and_call_original
      to_rdns_hostaddress(random_ip_v4_address)
    end
  end
end
