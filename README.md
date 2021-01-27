# Ruby DnsMock

[![Maintainability](https://api.codeclimate.com/v1/badges/5ea9da61ef468b8ad4c4/maintainability)](https://codeclimate.com/github/mocktools/ruby-dns-mock/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5ea9da61ef468b8ad4c4/test_coverage)](https://codeclimate.com/github/mocktools/ruby-dns-mock/test_coverage)
[![CircleCI](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/master.svg?style=svg)](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/master)
[![Gem Version](https://badge.fury.io/rb/dns_mock.svg)](https://badge.fury.io/rb/dns_mock)
[![Downloads](https://img.shields.io/gem/dt/dns_mock.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/dns_mock)
[![GitHub](https://img.shields.io/github/license/mocktools/ruby-dns-mock)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

💎 Ruby DNS mock. Mimic any DNS records for your test environment and even more.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Features

- Ability to mimic any DNS records (`A`, `AAAA`, `CNAME`, `MX`, `NS`, `PTR`, `SOA` and `TXT`)
- Zero runtime dependencies
- Lightweight UDP DNS mock server with dynamic/manual port assignment
- Test framework agnostic (it's PORO, so you can use it outside of `RSpec`, `Test::Unit` or `MiniTest`)
- Simple and intuitive DSL

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

    $ bundle

Or install it yourself as:

    $ gem install dns_mock

## Usage

```ruby
# Example of mocked DNS records structure
records = {
  'example.com' => {
    a: %w[1.1.1.1 2.2.2.2],
    aaaa: %w[2a00:1450:4001:81e::200e],
    ns: %w[ns1.domain.com ns2.domain.com],
    mx: %w[mx1.domain.com mx2.domain.com],
    txt: %w[txt_record_1 txt_record_2],
    cname: 'some.domain.com',
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
  '1.2.3.4' => {
    ptr: %w[domain_1.com domain_2.com]
  }
}

# Main DnsMock interface. records:Hash, port:Integer are an
# optional params. By default creates dns mock server with empty
# records. A free port for server will be randomly assigned in
# the range from 49152 to 65535. Returns current dns mock server
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mocktools/ruby-dns-mock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tikets](https://github.com/mocktools/ruby-dns-mock/issues). Be shure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DnsMock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Credits

- [The Contributors](https://github.com/mocktools/ruby-dns-mock/graphs/contributors) for code and awesome suggestions
- [The Stargazers](https://github.com/mocktools/ruby-dns-mock/stargazers) for showing their support

## Versioning

DnsMock uses [Semantic Versioning 2.0.0](https://semver.org)
