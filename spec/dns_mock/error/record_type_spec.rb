# frozen_string_literal: true

RSpec.describe DnsMock::Error::RecordType do
  subject(:error_instance) { described_class.new('record_type') }

  let(:error_context) { 'record_type is invalid record type' }

  it_behaves_like 'customized standard error'
end
