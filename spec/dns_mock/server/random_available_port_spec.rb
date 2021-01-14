# frozen_string_literal: true

RSpec.describe DnsMock::Server do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:CURRENT_HOST_NAME) }
    it { expect(described_class).to be_const_defined(:CURRENT_HOST_ADDRESS) }
  end
end

RSpec.describe DnsMock::Server::RandomAvailablePort do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:ATTEMPTS) }
    it { expect(described_class).to be_const_defined(:MIN_DYNAMIC_PORT_NUMBER) }
    it { expect(described_class).to be_const_defined(:MAX_DYNAMIC_PORT_NUMBER) }
  end

  describe '.call' do
    subject(:random_available_port) { described_class.call }

    let(:min_dynamic_port_number) { 49_998 }
    let(:max_dynamic_port_number) { 49_999 }

    before do
      stub_const('DnsMock::Server::RandomAvailablePort::MIN_DYNAMIC_PORT_NUMBER', min_dynamic_port_number)
      stub_const('DnsMock::Server::RandomAvailablePort::MAX_DYNAMIC_PORT_NUMBER', max_dynamic_port_number)
    end

    context 'when udp port is busy' do
      let(:busy_udp_port_number) { min_dynamic_port_number }
      let(:free_port_number) { max_dynamic_port_number }

      before { udp_service(busy_udp_port_number).bind! }

      after { udp_service.unbind! }

      include_examples 'random free upd & tcp port'
    end

    context 'when tcp port is busy' do
      let(:busy_tcp_port_number) { min_dynamic_port_number }
      let(:free_port_number) { max_dynamic_port_number }

      before { tcp_service(busy_tcp_port_number).bind! }

      after { tcp_service.unbind! }

      include_examples 'random free upd & tcp port'
    end

    context 'when both udp and tcp port are free' do
      let(:min_dynamic_port_number) { 49_997 }
      let(:busy_udp_port_number) { min_dynamic_port_number }
      let(:busy_tcp_port_number) { min_dynamic_port_number.next }
      let(:free_port_number) { max_dynamic_port_number }

      before do
        udp_service(busy_udp_port_number).bind!
        tcp_service(busy_tcp_port_number).bind!
      end

      after do
        udp_service.unbind!
        tcp_service.unbind!
      end

      include_examples 'random free upd & tcp port'
    end

    context 'when random free port not found, udp port is busy' do
      let(:attempts) { 1 }
      let(:max_dynamic_port_number) { 49_998 }
      let(:busy_port_number) { min_dynamic_port_number }

      before do
        stub_const('DnsMock::Server::RandomAvailablePort::ATTEMPTS', attempts)
        udp_service(busy_port_number).bind!
      end

      after { udp_service.unbind! }

      it do
        expect { random_available_port }
          .to raise_error(
            DnsMock::Error::RandomFreePort,
            "Impossible to find free random port in #{attempts} attempts"
          )
      end
    end

    context 'when random free port not found, tcp port is busy' do
      let(:attempts) { 1 }
      let(:max_dynamic_port_number) { 49_998 }
      let(:busy_port_number) { min_dynamic_port_number }

      before do
        stub_const('DnsMock::Server::RandomAvailablePort::ATTEMPTS', attempts)
        tcp_service(busy_port_number).bind!
      end

      after { tcp_service.unbind! }

      it do
        expect { random_available_port }
          .to raise_error(
            DnsMock::Error::RandomFreePort,
            "Impossible to find free random port in #{attempts} attempts"
          )
      end
    end
  end
end
