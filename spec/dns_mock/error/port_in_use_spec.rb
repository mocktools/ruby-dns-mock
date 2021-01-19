# frozen_string_literal: true

RSpec.describe DnsMock::Error::PortInUse do
  subject(:error_instance) { described_class.new('hostname', 5300) }

  let(:error_context) { 'Impossible to bind UDP DNS mock server on hostname:5300. Address already in use' }

  it_behaves_like 'customized runtime error'
end
