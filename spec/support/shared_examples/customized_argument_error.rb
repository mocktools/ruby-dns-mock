# frozen_string_literal: true

module DnsMock
  RSpec.shared_examples 'customized argument error' do
    it { expect(described_class).to be < ::ArgumentError }
    it { expect(error_instance).to be_an_instance_of(described_class) }
    it { expect(error_instance.to_s).to eq(error_context) }
  end
end
