# frozen_string_literal: true

require_relative 'dns_mock/core'

module DnsMock
  class << self
    def start_server(server = DnsMock::Server, records: {}, port: nil)
      server.new(records: records, port: port)
    end

    def running_servers
      ::ObjectSpace.each_object(DnsMock::Server).select(&:alive?)
    end

    def stop_running_servers!
      running_servers.all?(&:stop!)
    end
  end
end
