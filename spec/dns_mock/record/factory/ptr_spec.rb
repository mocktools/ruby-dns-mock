# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Ptr do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(dns_name, record_data: record_data).instance_params }

    let(:dns_name) { class_double('DnsName') }
    let(:dns_name_instance) { instance_double('DnsName') }
    let(:record_data) { 'some_record_context' }

    it 'returns prepared target class instance params' do
      expect(dns_name).to receive(:create).with("#{record_data}.").and_return(dns_name_instance)
      expect(instance_params).to eq([dns_name_instance])
    end
  end

  describe '#create' do
    subject(:create_factory) { described_class.new(record_data: record_data).create }

    context 'when valid record context' do
      shared_examples 'returns instance of target class' do
        it 'returns instance of target class' do
          expect(DnsMock::Representer::Punycode).to receive(:call).with(record_data).and_call_original
          expect(create_factory).to be_an_instance_of(described_class.target_class)
          expect(create_factory.name.to_s).to eq(converted_record_data)
        end
      end

      context 'when ASCII hostname' do
        let(:record_data) { random_hostname }
        let(:converted_record_data) { record_data }

        include_examples 'returns instance of target class'
      end

      context 'when non ASCII hostname' do
        let(:record_data) { random_non_ascii_hostname }
        let(:converted_record_data) { to_punycode_hostname(record_data) }

        include_examples 'returns instance of target class'
      end
    end

    context 'when invalid record context' do
      let(:record_data) { 42 }
      let(:error_context) { "cannot interpret as DNS name: #{record_data}. Invalid PTR record context" }

      it_behaves_like 'target class exception wrapper'
    end
  end
end
