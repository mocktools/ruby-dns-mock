# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Soa do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(record_data: record_data).instance_params }

    let(:dns_names) { ::Array.new(2) { random_hostname } }
    let(:int_params) { (0..5).to_a }
    let(:record_data) { dns_names + int_params }
    let(:expected_data) do
      [
        *dns_names.map { |item| create_dns_name(item) },
        *int_params
      ]
    end

    it 'returns prepared target class instance params' do
      expect(instance_params).to eq(expected_data)
    end
  end

  describe '#create' do
    subject(:create_factory) { described_class.new(record_data: record_data.values).create }

    let(:record_data) do
      {
        mname: mname,
        rname: rname,
        serial: 2_035_971_683,
        refresh: 10_000,
        retry: 2_400,
        expire: 604_800,
        minimum: 3_600
      }
    end

    context 'when valid record context' do
      shared_examples 'returns instance of target class' do
        it 'returns instance of target class' do
          expect(DnsMock::Representer::Punycode).to receive(:call).with(mname).and_call_original
          expect(DnsMock::Representer::Punycode).to receive(:call).with(rname).and_call_original
          expect(create_factory).to be_an_instance_of(described_class.target_class)
          dns_names = record_data.slice(:mname, :rname).transform_values do |value|
            create_dns_name(ascii_hostname ? value : to_punycode_hostname(value))
          end
          record_data.merge(dns_names).each { |key, value| expect(create_factory.public_send(key)).to eq(value) }
        end
      end

      context 'when ASCII hostname' do
        let(:ascii_hostname) { true }
        let(:mname) { random_hostname }
        let(:rname) { random_hostname }

        include_examples 'returns instance of target class'
      end

      context 'when non ASCII hostname' do
        let(:ascii_hostname) { false }
        let(:mname) { random_non_ascii_hostname }
        let(:rname) { random_non_ascii_hostname }

        include_examples 'returns instance of target class'
      end
    end

    context 'when invalid record context' do
      context 'when invalid mname' do
        let(:mname) { 42 }
        let(:rname) { random_hostname }
        let(:error_context) { "cannot interpret as DNS name: #{mname}. Invalid SOA record context" }

        it_behaves_like 'target class exception wrapper'
      end

      context 'when invalid rname' do
        let(:mname) { random_hostname }
        let(:rname) { 42 }
        let(:error_context) { "cannot interpret as DNS name: #{rname}. Invalid SOA record context" }

        it_behaves_like 'target class exception wrapper'
      end
    end
  end
end
