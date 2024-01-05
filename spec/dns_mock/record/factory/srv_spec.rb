# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Srv do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(record_data: record_data).instance_params }

    let(:int_params) { (0..3).to_a }
    let(:dns_name) { random_hostname }
    let(:record_data) { int_params + [dns_name] }
    let(:expected_data) do
      [
        *int_params,
        create_dns_name(dns_name)
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
        priority: 0,
        weight: 10,
        port: 5_060,
        target: target
      }
    end

    context 'when valid record context' do
      shared_examples 'returns instance of target class' do
        it 'returns instance of target class' do
          expect(DnsMock::Representer::Punycode).to receive(:call).with(target).and_call_original
          expect(create_factory).to be_an_instance_of(described_class.target_class)
          dns_names = record_data.slice(:target).transform_values do |value|
            create_dns_name(ascii_hostname ? value : to_punycode_hostname(value))
          end
          record_data.merge(dns_names).each { |key, value| expect(create_factory.public_send(key)).to eq(value) }
        end
      end

      context 'when ASCII hostname' do
        let(:ascii_hostname) { true }
        let(:target) { random_hostname }

        include_examples 'returns instance of target class'
      end

      context 'when non ASCII hostname' do
        let(:ascii_hostname) { false }
        let(:target) { random_non_ascii_hostname }

        include_examples 'returns instance of target class'
      end
    end

    context 'when invalid record context' do
      context 'when invalid mname' do
        let(:target) { 42 }
        let(:error_context) { "cannot interpret as DNS name: #{target}. Invalid SRV record context" }

        it_behaves_like 'target class exception wrapper'
      end
    end
  end
end
