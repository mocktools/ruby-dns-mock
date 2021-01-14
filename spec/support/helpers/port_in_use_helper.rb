# frozen_string_literal: true

module DnsMock
  module PortInUseHelper
    %i[udp_service tcp_service].each do |helper_method|
      define_method(helper_method) do |port_number = nil|
        target_accessor = :"current_#{helper_method}"
        target_instance = DnsMock::PortInUseHelper.const_get(helper_method.to_s.split('_').map(&:capitalize).join).new(port_number)
        port_number ? send(:"#{target_accessor}=", target_instance) : send(target_accessor)
      end
    end

    private

    attr_accessor :current_udp_service, :current_tcp_service

    class TransportService
      attr_reader :port, :socket

      def initialize(port, socket)
        @port = port
        @socket = socket
      end

      def bind!
        run
        self.binded = true
      end

      def unbind!
        return false unless binded
        socket.close
        !self.binded = false
      end

      private

      attr_accessor :binded

      def run; end
    end

    UdpService = ::Class.new(DnsMock::PortInUseHelper::TransportService) do
      def initialize(port, socket = ::UDPSocket.new)
        super
      end

      private

      def run
        socket.bind(DnsMock::Server::CURRENT_HOST_ADDRESS, port)
      end
    end

    TcpService = ::Class.new(DnsMock::PortInUseHelper::TransportService) do
      def initialize(port, socket = ::Socket.new(::Socket::AF_INET, ::Socket::SOCK_STREAM, 0))
        super
      end

      def run
        socket.bind(::Socket.sockaddr_in(port, DnsMock::Server::CURRENT_HOST_ADDRESS))
      end
    end
  end
end
