# frozen_string_literal: true

RSpec.describe DnsMock::Error::RecordHostType do
  subject(:error_instance) { described_class.new('hostname', 'hostname_class') }

  let(:error_context) { 'Hostname hostname type is hostname_class. Should be a String' }

  it_behaves_like 'customized standard error'
end
