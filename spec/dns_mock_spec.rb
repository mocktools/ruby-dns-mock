# frozen_string_literal: true

RSpec.describe DnsMock do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:AVAILABLE_DNS_RECORD_TYPES) }
  end
end
