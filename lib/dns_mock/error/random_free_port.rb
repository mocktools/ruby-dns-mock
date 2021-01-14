# frozen_string_literal: true

module DnsMock
  module Error
    RandomFreePort = ::Class.new(::RuntimeError) do
      def initialize(attempts)
        super("Impossible to find free random port in #{attempts} attempts")
      end
    end
  end
end
