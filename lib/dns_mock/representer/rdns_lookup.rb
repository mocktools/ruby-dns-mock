# frozen_string_literal: true

module DnsMock
  module Representer
    class RdnsLookup
      IP_OCTET_GROUPS = /(\d+).(\d+).(\d+).(\d+)/.freeze
      RDNS_LOOKUP_REPRESENTATION = '\4.\3.\2.\1.in-addr.arpa'

      def self.call(host_address)
        host_address.gsub(
          DnsMock::Representer::RdnsLookup::IP_OCTET_GROUPS,
          DnsMock::Representer::RdnsLookup::RDNS_LOOKUP_REPRESENTATION
        )
      end
    end
  end
end
