# frozen_string_literal: true

RSpec.describe DnsMock::PortInUseHelper, type: :helper do # rubocop:disable RSpec/FilePath
  let(:port_number) { 49_978 }

  describe '#udp_service' do
    context 'when port number is free' do
      it 'has the same port number' do
        expect(udp_service(port_number)).to be_an_instance_of(DnsMock::PortInUseHelper::UdpService)
        expect(udp_service.port).to eq(port_number)
      end

      it 'bind/unbind port' do
        udp_service(port_number)
        expect(udp_service.unbind!).to be(false)
        expect(udp_service.bind!).to be(true)
        expect(udp_service.unbind!).to be(true)
      end
    end

    context 'when port number is busy' do
      it do
        udp_service(port_number).bind!
        expect { udp_service.bind! }
          .to raise_error(
            ::Errno::EINVAL,
            "Invalid argument - bind(2) for \"#{DnsMock::Server::CURRENT_HOST_ADDRESS}\" port #{port_number}"
          )
        udp_service.unbind!
      end
    end
  end

  describe '#tcp_service' do
    context 'when port number is free' do
      it 'has the same port number' do
        expect(tcp_service(port_number)).to be_an_instance_of(DnsMock::PortInUseHelper::TcpService)
        expect(tcp_service.port).to eq(port_number)
      end

      it 'bind/unbind port' do
        tcp_service(port_number)
        expect(tcp_service.unbind!).to be(false)
        expect(tcp_service.bind!).to be(true)
        expect(tcp_service.unbind!).to be(true)
      end
    end

    context 'when port number is busy' do
      it do
        tcp_service(port_number).bind!
        expect { tcp_service.bind! }
          .to raise_error(
            ::Errno::EINVAL,
            "Invalid argument - bind(2) for #{DnsMock::Server::CURRENT_HOST_ADDRESS}:#{port_number}"
          )
        tcp_service.unbind!
      end
    end
  end
end
