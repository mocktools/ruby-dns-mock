# frozen_string_literal: true

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
  subject(:error_instance) { described_class.new('record_context_type', 'expected_type') }

  let(:error_context) { 'record_context_type is invalid record context type. Should be a expected_type' }

  it_behaves_like 'customized error'
end
