# frozen_string_literal: true

module DnsMock
  RSpec.shared_examples 'customized error' do
    it { expect(described_class).to be < StandardError }
    it { expect(error_instance).to be_an_instance_of(described_class) }
    it { expect(error_instance.to_s).to eq(error_context) }
  end
end
