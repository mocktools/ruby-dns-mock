# frozen_string_literal: true

module DnsMock
  module ServerHelper
    def start_random_server(total: 1)
      servers = ::Array.new(total) { DnsMock.start_server }
      total.eql?(1) ? servers.first : servers
    end

    def stop_all_running_servers
      DnsMock.stop_running_servers!
    end
  end
end
