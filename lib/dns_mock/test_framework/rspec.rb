# frozen_string_literal: true

require 'rspec/core'
require_relative '../../dns_mock'
require_relative 'rspec/interface'
require_relative 'rspec/helper'

RSpec.configure do |config|
  config.before(:suite) { DnsMock::TestFramework::RSpec::Interface.start_server }
  config.after(:suite) { DnsMock::TestFramework::RSpec::Interface.stop_server! }
  config.after { DnsMock::TestFramework::RSpec::Interface.reset_mocks! }
end
