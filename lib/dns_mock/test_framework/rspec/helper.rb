# frozen_string_literal: true

require_relative 'interface'

module DnsMock
  module TestFramework
    module RSpec
      module Helper
        def dns_mock_server(**options)
          DnsMock::TestFramework::RSpec::Interface.start_server(**options)
        end
      end
    end
  end
end
