# frozen_string_literal: true

RSpec.describe DnsMock::Representer::RdnsLookup do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:IP_OCTET_GROUPS) }
    it { expect(described_class).to be_const_defined(:RDNS_LOOKUP_REPRESENTATION) }
  end

  describe '.call' do
    subject(:rdns_lookup_representer) { described_class.call(host_address) }

    context 'when hostname includes ASCII chars only' do
      let(:host_address) { random_ip_v4_address }
      let(:rdns_lookup_prefix) { '.in-addr.arpa' }
      let(:rdns_lookup_host_address_representation) do
        "#{host_address.split('.').reverse.join('.')}#{rdns_lookup_prefix}"
      end

      it 'returns hostname without convertion' do
        expect(rdns_lookup_representer).to eq(rdns_lookup_host_address_representation)
      end
    end
  end
end
