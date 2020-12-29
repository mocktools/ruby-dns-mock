# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Soa do
  it { expect(described_class).to be < DnsMock::Record::Factory::Base }

  describe '#instance_params' do
    subject(:instance_params) { described_class.new(record_data: record_data).instance_params }

    let(:dns_names) { Array.new(2) { random_hostname } }
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
        mname: random_hostname,
        rname: random_hostname,
        serial: 2_035_971_683,
        refresh: 10_000,
        retry: 2_400,
        expire: 604_800,
        minimum: 3_600
      }
    end

    it 'returns instance of target class' do
      expect(create_factory).to be_an_instance_of(described_class.target_class)
      dns_names = record_data.slice(:mname, :rname).transform_values { |value| create_dns_name(value) }
      record_data.merge(dns_names).each { |key, value| expect(create_factory.public_send(key)).to eq(value) }
    end
  end
end
