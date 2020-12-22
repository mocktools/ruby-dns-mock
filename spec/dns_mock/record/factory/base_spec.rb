# frozen_string_literal: true

RSpec.describe DnsMock::Record::Factory::Base do
  describe 'defined constants' do
    specify { expect(described_class).to be_const_defined(:DNS_RECORD_TYPES) }
  end

  describe '.record_type' do
    subject(:record_type) { Class.new(described_class).record_type(defined_record_type) }

    context 'when invalid record type' do
      let(:defined_record_type) { :invalid_record_type }

      it do
        expect { record_type }
          .to raise_error(DnsMock::RecordTypeError, "#{defined_record_type} is invalid record type")
      end
    end
  end
end
