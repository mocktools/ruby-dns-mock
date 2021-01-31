# frozen_string_literal: true

require_relative '../../../../lib/dns_mock/test_framework/rspec/interface'

RSpec.describe DnsMock::TestFramework::RSpec::Interface do
  after { described_class.clear_server! }

  describe '.start_server' do
    let(:dns_mock_server_instance) { instance_double('DnsMockServerInstance') }

    context 'with kwargs' do
      subject(:start_server) { described_class.start_server(**options) }

      let(:records) { random_records }
      let(:port) { random_port_number }
      let(:options) { { records: records, port: port } }

      it do
        expect(DnsMock).to receive(:start_server).with(**options).and_return(dns_mock_server_instance)
        expect(start_server).to eq(dns_mock_server_instance)
      end
    end

    context 'without kwargs' do
      subject(:start_server) { described_class.start_server }

      it do
        expect(DnsMock).to receive(:start_server).and_return(dns_mock_server_instance)
        expect(start_server).to eq(dns_mock_server_instance)
      end
    end
  end

  describe '.stop_server!' do
    subject(:stop_server) { described_class.stop_server! }

    context 'when dns mock server exists' do
      before { described_class.start_server }

      after { stop_all_running_servers }

      it { is_expected.to be(true) }
    end

    context 'when dns mock server not exists' do
      it { is_expected.to be_nil }
    end
  end

  describe '.reset_mocks!' do
    subject(:stop_server) { described_class.reset_mocks! }

    context 'when dns mock server exists' do
      before { described_class.start_server }

      after { stop_all_running_servers }

      it { is_expected.to be(true) }
    end

    context 'when dns mock server not exists' do
      it { is_expected.to be_nil }
    end
  end

  describe 'clear_server!' do
    subject(:clear_server) { described_class.clear_server! }

    it { is_expected.to be_nil }
  end
end
