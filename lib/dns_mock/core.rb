# frozen_string_literal: true

require 'resolv'
require 'socket'

module DnsMock
  AVAILABLE_DNS_RECORD_TYPES = %i[a aaaa cname mx ns ptr soa txt].freeze

  module Error
    require_relative '../dns_mock/error/argument_type'
    require_relative '../dns_mock/error/port_in_use'
    require_relative '../dns_mock/error/random_free_port'
    require_relative '../dns_mock/error/record_context_type'
    require_relative '../dns_mock/error/record_context'
    require_relative '../dns_mock/error/record_host_type'
    require_relative '../dns_mock/error/record_not_found'
    require_relative '../dns_mock/error/record_type'
    require_relative '../dns_mock/error/helper'
  end

  module Representer
    require_relative '../dns_mock/representer/punycode'
    require_relative '../dns_mock/representer/rdns_lookup'
  end

  module Record
    module Factory
      require_relative '../dns_mock/record/factory/base'
      require_relative '../dns_mock/record/factory/a'
      require_relative '../dns_mock/record/factory/aaaa'
      require_relative '../dns_mock/record/factory/cname'
      require_relative '../dns_mock/record/factory/mx'
      require_relative '../dns_mock/record/factory/ns'
      require_relative '../dns_mock/record/factory/ptr'
      require_relative '../dns_mock/record/factory/soa'
      require_relative '../dns_mock/record/factory/txt'
    end
  end

  module Record
    module Builder
      require_relative '../dns_mock/record/builder/base'
      require_relative '../dns_mock/record/builder/a'
      require_relative '../dns_mock/record/builder/aaaa'
      require_relative '../dns_mock/record/builder/cname'
      require_relative '../dns_mock/record/builder/mx'
      require_relative '../dns_mock/record/builder/ns'
      require_relative '../dns_mock/record/builder/ptr'
      require_relative '../dns_mock/record/builder/soa'
      require_relative '../dns_mock/record/builder/txt'
    end
  end

  module Response
    require_relative '../dns_mock/response/answer'
    require_relative '../dns_mock/response/message'
  end

  require_relative '../dns_mock/version'
  require_relative '../dns_mock/server/records_dictionary_builder'
  require_relative '../dns_mock/server'
end
