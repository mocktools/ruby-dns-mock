# Ruby DnsMock

[![CircleCI](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/develop.svg?style=svg)](https://circleci.com/gh/mocktools/ruby-dns-mock/tree/develop)
[![Gem Version](https://badge.fury.io/rb/dns_mock.svg)](https://badge.fury.io/rb/dns_mock)
[![Downloads](https://img.shields.io/gem/dt/dns_mock.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/dns_mock)
[![GitHub](https://img.shields.io/github/license/mocktools/ruby-dns-mock)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

Ruby MRI 2.5.0+

## Features

- Ability to mimic any DNS records for your test environment
- Zero runtime dependencies
- Test framework agnostic (`RSpec`, `Test::Unit`, `MiniTest`). Even can be used outside of test frameworks

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
# Example of mocked DNS records
records = {
  'example.com' => {
    a: %w[1.1.1.1, 2.2.2.2],
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
  }
}

# Main DnsMock interface:
dns_mock_server = DnsMock.start_server(records: records) # records, port are an optional params
dns_mock_server.port
dns_mock_server.assign_mocks(records)
dns_mock_server.reset_mocks!
dns_mock_server.stop!

DnsMock.running_servers
DnsMock.stop_running_servers!
```
