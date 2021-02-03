# frozen_string_literal: true

RSpec.describe DnsMock::Record::Builder::Mx do
  describe 'class dependencies' do
    subject(:builder_class) { described_class }

    it { is_expected.to be < DnsMock::Record::Builder::Base }
    it { is_expected.to be_const_defined(:MX_RECORD_REGEX_PATTERN) }
    it { is_expected.to be_const_defined(:RECORD_PREFERENCE_STEP) }
  end

  describe 'MX_RECORD_REGEX_PATTERN' do
    subject(:regex_pattern) { described_class::MX_RECORD_REGEX_PATTERN }

    context 'when host with priority' do
      subject(:string) { "#{host}:#{priority}" }

      let(:host) { random_hostname }
      let(:priority) { rand(100).to_s }

      it { expect(regex_pattern.match?(string)).to be(true) }
      it { expect(string[regex_pattern, 1]).to eq(host) }
      it { expect(string[regex_pattern, 2]).to eq(priority) }
    end

    context 'when host without priority' do
      subject(:string) { random_hostname }

      it { expect(regex_pattern.match?(string)).to be(true) }
      it { expect(string[regex_pattern, 3]).to eq(string) }
    end
  end

  describe '.call' do
    subject(:builder) { described_class.call(target_factory, records_data) }

    let(:target_factory) { class_double('TargetFactory') }

    describe 'Success' do
      context 'when valid records_data nested type' do
        let(:target_class_instance) { instance_double('TargetClass') }
        let(:target_factory_instance) { instance_double('TargetFactory', create: target_class_instance) }
        let(:mx_host) { random_hostname }
        let(:mx_priority) { 0 }
        let(:records_data) { ["#{mx_host}:#{mx_priority}", 'b', 'c'] }

        it 'returns array of target class instances' do
          [10, 20, 30].zip(records_data).each_with_index do |(record_preference, record_data), index|
            expect(target_factory)
              .to receive(:new)
              .with(record_data: index.zero? ? [mx_priority, mx_host] : [record_preference, record_data])
              .and_return(target_factory_instance)
          end
          expect(builder).to eq(::Array.new(records_data.size) { target_class_instance })
        end
      end
    end

    describe 'Failure' do
      context 'when invalid records_data nested type' do
        let(:record_data_object) { 42 }
        let(:records_data) { [record_data_object] }

        it do
          expect { builder }.to raise_error(
            DnsMock::Error::RecordContextType,
            "#{record_data_object.class} is invalid record context type for MX record. Should be a String"
          )
        end
      end
    end
  end
end
