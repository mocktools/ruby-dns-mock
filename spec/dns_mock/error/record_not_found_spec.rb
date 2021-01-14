# frozen_string_literal: true

RSpec.describe DnsMock::Error::RecordNotFound do
  subject(:error_instance) { described_class.new('record_type', 'hostname') }

  let(:error_context) { 'record_type not found for hostname in predefined records dictionary' }

  it_behaves_like 'customized standard error'
end
