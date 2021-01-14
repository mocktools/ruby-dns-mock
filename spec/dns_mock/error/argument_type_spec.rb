# frozen_string_literal: true

RSpec.describe DnsMock::Error::ArgumentType do
  subject(:error_instance) { described_class.new('SomeClassName') }

  let(:error_context) { 'Argument class is a SomeClassName. Should be a Hash' }

  it_behaves_like 'customized standard error'
end
