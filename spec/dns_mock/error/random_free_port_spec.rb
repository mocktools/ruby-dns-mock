# frozen_string_literal: true

RSpec.describe DnsMock::Error::RandomFreePort do
  subject(:error_instance) { described_class.new(42) }

  it { expect(described_class).to be < ::RuntimeError }
  it { expect(error_instance).to be_an_instance_of(described_class) }
  it { expect(error_instance.to_s).to eq('Impossible to find free random port in 42 attempts') }
end
