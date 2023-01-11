# frozen_string_literal: true

module DnsMock
  class Server
    include DnsMock::Error::Helper

    CURRENT_HOST_NAME = 'localhost'
    CURRENT_HOST_ADDRESS = '127.0.0.1'
    WARMUP_DELAY = 0.1
    PACKET_MAX_BYTES_SIZE = 65_535

    attr_reader :port

    def initialize( # rubocop:disable Metrics/ParameterLists
      socket = ::UDPSocket.new,
      records_dictionary_builder = DnsMock::Server::RecordsDictionaryBuilder,
      thread_class = ::Thread,
      records: nil,
      port: nil,
      exception_if_not_found: false
    )
      @socket = socket
      @records_dictionary_builder = records_dictionary_builder
      @thread_class = thread_class
      @records = records_dictionary_builder.call(records || {})
      @port = port || 0
      @exception_if_not_found = exception_if_not_found
      prepare_server_thread
    end

    def run
      prepare_socket_for_session
      update_server_port

      begin
        loop do
          packet, addr = socket.recvfrom(DnsMock::Server::PACKET_MAX_BYTES_SIZE)
          break if packet.empty?

          address, port = addr.values_at(3, 1)
          socket.send(DnsMock::Response::Message.new(packet, records, exception_if_not_found).as_binary_string, 0, address, port)
        end
      ensure
        socket.close
      end
    end

    def assign_mocks(new_records)
      !!self.records = records_dictionary_builder.call(new_records) if records.empty?
    end

    def reset_mocks!
      records.clear.empty?
    end

    def without_mocks?
      records.empty?
    end

    def alive?
      thread.alive?
    end

    def stop!
      thread.kill.stop?
    end

    private

    attr_reader :socket, :records_dictionary_builder, :thread_class, :exception_if_not_found
    attr_writer :port
    attr_accessor :records, :thread

    def prepare_socket_for_session
      ::Socket.do_not_reverse_lookup = true
      socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, true)
      socket.bind(DnsMock::Server::CURRENT_HOST_NAME, port)
    rescue ::Errno::EADDRINUSE
      raise DnsMock::Error::PortInUse.new(DnsMock::Server::CURRENT_HOST_NAME, port)
    end

    def update_server_port
      self.port = socket.addr[1] if port.zero?
    end

    def prepare_server_thread
      self.thread = thread_class.new { run }
      thread.join(DnsMock::Server::WARMUP_DELAY)
    end
  end
end
