# frozen_string_literal: true

module DnsMock
  class Server
    CURRENT_HOST_NAME = 'localhost'
    CURRENT_HOST_ADDRESS = '127.0.0.1'

    class RandomAvailablePort
      ATTEMPTS = 100
      MIN_DYNAMIC_PORT_NUMBER = 49_152
      MAX_DYNAMIC_PORT_NUMBER = 65_535

      class << self
        def call
          DnsMock::Server::RandomAvailablePort::ATTEMPTS.times do
            port = rand(
              DnsMock::Server::RandomAvailablePort::MIN_DYNAMIC_PORT_NUMBER..DnsMock::Server::RandomAvailablePort::MAX_DYNAMIC_PORT_NUMBER
            )
            return port if port_free?(port)
          end
          raise DnsMock::RandomFreePortError, DnsMock::Server::RandomAvailablePort::ATTEMPTS
        end

        private

        def udp_port_free?(port, socket = ::UDPSocket.new)
          socket.bind(DnsMock::Server::CURRENT_HOST_NAME, port)
          socket.close
          true
        rescue ::Errno::EADDRINUSE
          false
        end

        def tcp_port_free?(port, socket = ::Socket.new(::Socket::AF_INET, ::Socket::SOCK_STREAM, 0))
          socket.bind(::Socket.sockaddr_in(port, DnsMock::Server::CURRENT_HOST_ADDRESS))
          socket.close
          true
        rescue ::Errno::EADDRINUSE
          false
        end

        def port_free?(port)
          udp_port_free?(port) && tcp_port_free?(port)
        end
      end
    end
  end
end
