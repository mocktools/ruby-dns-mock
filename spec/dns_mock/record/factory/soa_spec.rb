# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Soa do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(record_data: record_data).instance_params }

    let(:record_data) { 'some_record_context' }

    it 'returns prepared target class instance params' do
      expect(instance_params).to eq(record_data)
    end
  end

  describe '#create' do
    subject(:create_factory) { described_class.new(record_data: record_data.values).create }

    let(:record_data) do
      {
        mname: 'dns1.domain.com',
        rname: 'dns2.domain.com',
        serial: 2_035_971_683,
        refresh: 10_000,
        retry: 2_400,
        expire: 604_800,
        minimum: 3_600
      }
    end

    it 'returns instance of target class' do
      expect(create_factory).to be_an_instance_of(described_class.target_class)
      record_data.each { |key, value| expect(create_factory.public_send(key)).to eq(value) }
    end
  end
end
