# frozen_string_literal: true

RSpec.describe DnsMock::Record::Builder::Cname do
  describe 'class dependencies' do
    subject(:builder_class) { described_class }

    it { is_expected.to be < DnsMock::Record::Builder::Base }
  end

  describe '.call' do
    subject(:builder) { described_class.call(target_factory, record_data) }

    let(:target_factory) { class_double('TargetFactory') }
    let(:target_class_instance) { instance_double('TargetClass') }
    let(:target_factory_instance) { instance_double('TargetFactory', create: target_class_instance) }
    let(:record_data) { 'record_data' }

    it 'returns array with one target class instance' do
      expect(target_factory).to receive(:new).with(record_data: record_data).and_return(target_factory_instance)
      expect(builder).to eq([target_class_instance])
    end
  end
end
