# frozen_string_literal: true

RSpec.describe DnsMock::Error::RecordContextType do
  subject(:error_instance) { described_class.new('record_context_type', 'record_type', 'expected_type') }

  let(:error_context) { 'record_context_type is invalid record context type for record_type record. Should be a expected_type' }

  it_behaves_like 'customized standard error'
end
