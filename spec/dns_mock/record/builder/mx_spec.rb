# frozen_string_literal: true

RSpec.describe DnsMock::Record::Builder::Mx do
  describe 'class dependencies' do
    subject(:builder_class) { described_class }

    it { is_expected.to be < DnsMock::Record::Builder::Base }
    it { is_expected.to be_const_defined(:RECORD_PREFERENCE_STEP) }
  end

  describe '.call' do
    subject(:builder) { described_class.call(target_factory, records_data) }

    let(:target_factory) { class_double('TargetFactory') }
    let(:target_class_instance) { instance_double('TargetClass') }
    let(:target_factory_instance) { instance_double('TargetFactory', create: target_class_instance) }
    let(:records_data) { (0..2) }

    it 'returns array of target class instances' do
      [10, 20, 30].zip(records_data).each do |record_preference, record_data|
        expect(target_factory)
          .to receive(:new)
          .with(record_data: [record_preference, record_data])
          .and_return(target_factory_instance)
      end
      expect(builder).to eq(::Array.new(records_data.size) { target_class_instance })
    end
  end
end
