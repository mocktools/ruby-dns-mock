# frozen_string_literal: true

module DnsMock
  module Error
    PortInUse = ::Class.new(::RuntimeError) do
      def initialize(hostname, port)
        super("Impossible to bind UDP DNS mock server on #{hostname}:#{port}. Address already in use")
      end
    end
  end
end
