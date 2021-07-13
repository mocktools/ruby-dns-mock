# frozen_string_literal: true

RSpec.describe DnsMock::Representer::Punycode do
  describe '.call' do
    subject(:punycode_representer) { described_class.call(hostname) }

    context 'when hostname includes ASCII chars only' do
      let(:hostname) { random_hostname }

      it 'returns hostname without convertion' do
        expect(SimpleIDN).not_to receive(:to_ascii).with(hostname)
        expect(punycode_representer).to eq(hostname)
      end
    end

    context 'when hostname includes not ASCII chars' do
      let(:hostname) { 'mañana.cøm' }

      it 'returns converted to ASCII hostname' do
        expect(SimpleIDN).to receive(:to_ascii).with(hostname).and_call_original
        expect(punycode_representer).to eq('xn--maana-pta.xn--cm-lka')
      end
    end
  end
end
