# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Aaaa do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(record_data: record_data).instance_params }

    let(:record_data) { 'some_record_context' }

    it 'returns prepared target class instance params' do
      expect(instance_params).to eq(record_data)
    end
  end

  describe '#create' do
    subject(:create_factory) { described_class.new(record_data: record_data).create }

    context 'when valid record context' do
      let(:record_data) { Faker::Internet.ip_v6_address }

      it 'returns instance of target class' do
        expect(create_factory).to be_an_instance_of(described_class.target_class)
        expect(create_factory.address.to_s).to eq(record_data.upcase)
      end
    end

    context 'when invalid record context' do
      let(:record_data) { 'not_ip_v6_address' }
      let(:error_context) { "not numeric IPv6 address: #{record_data}. Invalid AAAA record context" }

      it_behaves_like 'target class exception wrapper'
    end
  end
end
