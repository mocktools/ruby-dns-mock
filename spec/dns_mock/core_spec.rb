# frozen_string_literal: true

RSpec.describe DnsMock do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:AVAILABLE_DNS_RECORD_TYPES) }
  end
end

RSpec.describe DnsMock::RecordTypeError do
  subject(:error_instance) { described_class.new('record_type') }

  let(:error_context) { 'record_type is invalid record type' }

  it_behaves_like 'customized error'
end

RSpec.describe DnsMock::RecordContextError do
  subject(:error_instance) { described_class.new('record_data', 'record_type') }

  let(:error_context) { 'record_data. Invalid record_type record context' }

  it_behaves_like 'customized error'
end

RSpec.describe DnsMock::RecordContextTypeError do
  subject(:error_instance) { described_class.new('record_context_type', 'record_type', 'expected_type') }

  let(:error_context) { 'record_context_type is invalid record context type for record_type record. Should be a expected_type' }

  it_behaves_like 'customized error'
end

RSpec.describe DnsMock::RecordNotFoundError do
  subject(:error_instance) { described_class.new('record_type', 'hostname') }

  let(:error_context) { 'record_type not found for hostname in predefined records dictionary' }

  it_behaves_like 'customized error'
end
