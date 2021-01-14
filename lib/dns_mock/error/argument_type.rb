# frozen_string_literal: true

module DnsMock
  module Error
    ArgumentType = ::Class.new(::ArgumentError) do
      def initialize(argument_class)
        super("Argument class is a #{argument_class}. Should be a Hash")
      end
    end
  end
end
