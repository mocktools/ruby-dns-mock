# frozen_string_literal: true

module DnsMock
  class Server
    include DnsMock::Error::Helper

    WARMUP_DELAY = 0.1
    PACKET_MAX_BYTES_SIZE = 65_535

    attr_reader :port

    def initialize( # rubocop:disable Metrics/ParameterLists
      socket = ::UDPSocket.new,
      records_dictionary_builder = DnsMock::Server::RecordsDictionaryBuilder,
      random_available_port = DnsMock::Server::RandomAvailablePort,
      thread_class = ::Thread,
      records: nil,
      port: nil
    )
      @socket = socket
      @records_dictionary_builder = records_dictionary_builder
      @thread_class = thread_class
      @records = records_dictionary_builder.call(records || {})
      @port = port || random_available_port.call
      prepare_server_thread
    end

    def run
      prepare_socket_for_session

      begin
        loop do
          packet, addr = socket.recvfrom(DnsMock::Server::PACKET_MAX_BYTES_SIZE)
          break if packet.size.zero?

          address, port = addr.values_at(3, 1)
          socket.send(DnsMock::Response::Message.new(packet, records).as_binary_string, 0, address, port)
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

    attr_reader :socket, :records_dictionary_builder, :thread_class
    attr_accessor :records, :thread

    def prepare_socket_for_session
      ::Socket.do_not_reverse_lookup = true
      socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, true)
      socket.bind(DnsMock::Server::CURRENT_HOST_NAME, port)
    rescue ::Errno::EADDRINUSE
      raise DnsMock::Error::PortInUse.new(DnsMock::Server::CURRENT_HOST_NAME, port)
    end

    def prepare_server_thread
      self.thread = thread_class.new { run }
      thread.join(DnsMock::Server::WARMUP_DELAY)
    end
  end
end
