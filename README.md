# ![Ruby DnsMock - mimic any DNS records for your test environment and even more!](https://repository-images.githubusercontent.com/323097031/ba2a0780-df26-11eb-954b-5e3204587eb2)

[![Maintainability](https://api.codeclimate.com/v1/badges/5ea9da61ef468b8ad4c4/maintainability)](https://codeclimate.com/github/mocktools/ruby-dns-mock/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5ea9da61ef468b8ad4c4/test_coverage)](https://codeclimate.com/github/mocktools/ruby-dns-mock/test_coverage)
[![CircleCI](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/master.svg?style=svg)](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/master)
[![Gem Version](https://badge.fury.io/rb/dns_mock.svg)](https://badge.fury.io/rb/dns_mock)
[![Downloads](https://img.shields.io/gem/dt/dns_mock.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/dns_mock)
[![In Awesome Ruby](https://raw.githubusercontent.com/sindresorhus/awesome/main/media/mentioned-badge.svg)](https://github.com/markets/awesome-ruby)
[![GitHub](https://img.shields.io/github/license/mocktools/ruby-dns-mock)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

💎 Ruby DNS mock. Mimic any DNS records for your test environment and even more.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [RSpec](#rspec)
    - [DnsMock RSpec helper](#dnsmock-rspec-helper)
    - [DnsMock RSpec interface](#dnsmock-rspec-interface)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Features

- Ability to mimic any DNS records (`A`, `AAAA`, `CNAME`, `MX`, `NS`, `PTR`, `SOA` and `TXT`)
- Automatically converts host names to RDNS/[Punycode](https://en.wikipedia.org/wiki/Punycode) representation
- Lightweight UDP DNS mock server with dynamic/manual port assignment
- Test framework agnostic (it's PORO, so you can use it outside of `RSpec`, `Test::Unit` or `MiniTest`)
- Simple and intuitive DSL
- Only one runtime dependency

## Requirements

Ruby MRI 2.5.0+

## Installation

Add this line to your application's `Gemfile`:

```ruby
group :development, :test do
  gem 'dns_mock', require: false
end
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install dns_mock
```

## Usage

```ruby
# Example of mocked DNS records, please follow this data structure
records = {
  'example.com' => {
    a: %w[1.1.1.1 2.2.2.2],
    aaaa: %w[2a00:1450:4001:81e::200e],
    ns: %w[ns1.domain.com ns2.domain.com],
    mx: %w[mx1.domain.com mx2.domain.com:50], # you can specify host(s) or host(s) with priority, use '.:0' for definition null MX record
    txt: %w[txt_record_1 txt_record_2],
    cname: 'mañana.com', # you can specify hostname in UTF-8. It will be converted to xn--maana-pta.com automatically
    soa: [
      {
        mname: 'dns1.domain.com',
        rname: 'dns2.domain.com',
        serial: 2_035_971_683,
        refresh: 10_000,
        retry: 2_400,
        expire: 604_800,
        minimum: 3_600
      }
    ]
  },
  '1.2.3.4' => { # You can define RDNS host address without lookup prefix. It will be converted to 4.3.2.1.in-addr.arpa automatically
    ptr: %w[domain_1.com domain_2.com]
  }
}

# Public DnsMock interface
# records:Hash, port:Integer, exception_if_not_found:Boolean
# are optional params. By default creates dns mock server with
# empty records. A free port for server will be randomly assigned
# in the range from 49152 to 65535, if record not found exception
# won't raises. Please note if you specify zero port number,
# free port number will be randomly assigned as a server port too.
# Returns current dns mock server
dns_mock_server = DnsMock.start_server(records: records) # => DnsMock::Server instance

# returns current dns mock server port
dns_mock_server.port # => 49322

# interface to setup mock records.
# Available only in case when server mocked records is empty
dns_mock_server.assign_mocks(records) # => true/nil

# interface to reset current mocked records
dns_mock_server.reset_mocks! # => true

# interface to stop current dns mock server
dns_mock_server.stop! # => true

# returns list of running dns mock servers
DnsMock.running_servers # => [DnsMock::Server instance]

# interface to stop all running dns mock servers
DnsMock.stop_running_servers! # => true
```

### RSpec

Require this either in your Gemfile or in RSpec's support scripts. So either:

```ruby
# Gemfile
group :test do
  gem 'rspec'
  gem 'dns_mock', require: 'dns_mock/test_framework/rspec'
end
```

or

```ruby
# spec/support/config/dns_mock.rb
require 'dns_mock/test_framework/rspec'
```

#### DnsMock RSpec helper

Just add `DnsMock::TestFramework::RSpec::Helper` if you wanna use shortcut `dns_mock_server` for DnsMock server instance inside of your `RSpec.describe` blocks:

```ruby
# spec/support/config/dns_mock.rb
RSpec.configure do |config|
  config.include DnsMock::TestFramework::RSpec::Helper
end
```

```ruby
# your awesome first_a_record_spec.rb
RSpec.describe FirstARecord do
  subject(:service) do
    described_class.call(
      hostname,
      dns_gateway_host: 'localhost',
      dns_gateway_port: dns_mock_server.port
    )
  end

  let(:hostname) { 'example.com' }
  let(:first_a_record) { '1.2.3.4' }
  let(:records) { { hostname => { a: [first_a_record] } } }

  before { dns_mock_server.assign_mocks(records) }

  it { is_expected.to eq(first_a_record) }
end
```

#### DnsMock RSpec interface

If you won't use `DnsMock::TestFramework::RSpec::Helper` you can use `DnsMock::TestFramework::RSpec::Interface` directly instead:

```ruby
DnsMock::TestFramework::RSpec::Interface.start_server  # creates and runs DnsMock server instance
DnsMock::TestFramework::RSpec::Interface.stop_server!  # stops current DnsMock server instance
DnsMock::TestFramework::RSpec::Interface.reset_mocks!  # resets mocks in current DnsMock server instance
DnsMock::TestFramework::RSpec::Interface.clear_server! # stops and clears current DnsMock server instance
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/mocktools/ruby-dns-mock>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tickets](https://github.com/mocktools/ruby-dns-mock/issues). Be sure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DnsMock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Credits

- [The Contributors](https://github.com/mocktools/ruby-dns-mock/graphs/contributors) for code and awesome suggestions
- [The Stargazers](https://github.com/mocktools/ruby-dns-mock/stargazers) for showing their support

## Versioning

DnsMock uses [Semantic Versioning 2.0.0](https://semver.org)
