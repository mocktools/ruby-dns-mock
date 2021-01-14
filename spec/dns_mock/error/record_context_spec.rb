# frozen_string_literal: true

RSpec.describe DnsMock::Error::RecordContext do
  subject(:error_instance) { described_class.new('record_data', 'record_type') }

  let(:error_context) { 'record_data. Invalid record_type record context' }

  it_behaves_like 'customized standard error'
end
