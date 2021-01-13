# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Txt do
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

    let(:record_data) { random_txt_record_context }

    it 'returns instance of target class' do
      expect(create_factory).to be_an_instance_of(described_class.target_class)
      expect(create_factory.strings).to eq([record_data])
    end
  end
end
