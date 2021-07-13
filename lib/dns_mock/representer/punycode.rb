# frozen_string_literal: true

module DnsMock
  module Representer
    Punycode = ::Class.new do
      require 'simpleidn'

      def self.call(hostname)
        return hostname if hostname.ascii_only?

        SimpleIDN.to_ascii(hostname)
      end
    end
  end
end
