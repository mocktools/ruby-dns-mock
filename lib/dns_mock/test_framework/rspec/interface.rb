# frozen_string_literal: true

module DnsMock
  module TestFramework
    module RSpec
      module Interface
        class << self
          def start_server(**options)
            @dns_mock_server ||= DnsMock.start_server(**options) # rubocop:disable Naming/MemoizedInstanceVariableName
          end

          def stop_server!
            return unless dns_mock_server

            dns_mock_server.stop!
          end

          def reset_mocks!
            return unless dns_mock_server

            dns_mock_server.reset_mocks!
          end

          def clear_server!
            @dns_mock_server = nil
          end

          private

          attr_reader :dns_mock_server
        end
      end
    end
  end
end
