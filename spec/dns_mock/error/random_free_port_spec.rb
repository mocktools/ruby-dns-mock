# frozen_string_literal: true

RSpec.describe DnsMock::Error::RandomFreePort do
  subject(:error_instance) { described_class.new(42) }

  let(:error_context) { 'Impossible to find free random port in 42 attempts' }

  it_behaves_like 'customized runtime error'
end
