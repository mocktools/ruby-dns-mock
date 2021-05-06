# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.2] - 2021-05-06

### Changed

- Updated gem development dependencies
- Updated rubocop/codeclimate config
- Updated ci config

## [1.2.1] - 2021-03-23

### Changed

- Updated gem development dependencies
- Updated rubocop/codeclimate config
- Updated gem documentation
- Updated tests

## [1.2.0] - 2021-02-04

### Ability to specify MX record priority

Added ability to specify custom priority of MX record if it needed. Now it impossible to define null or backup MX records. Please note, if you haven't specified a priority of MX record, it will be assigned automatically. MX records builder is assigning priority with step 10 from first item of defined MX records array.

```ruby
records = {
  'example.com' => {
    mx: %w[.:0 mx1.domain.com:10 mx2.domain.com:10 mx3.domain.com] # .:0 - null MX record
  }
}

DnsMock.start_server(records: records)
```

```bash
dig @localhost -p 5300 MX example.com
```

```
; <<>> DiG 9.10.6 <<>> @localhost -p 5300 MX example.com

;; ANSWER SECTION:
example.com.		1	IN	MX	0 .
example.com.		1	IN	MX	10 mx1.domain.com.
example.com.		1	IN	MX	10 mx2.domain.com.
example.com.		1	IN	MX	40 mx3.domain.com.

;; Query time: 0 msec
;; SERVER: 127.0.0.1#5300(127.0.0.1)
;; WHEN: Wed Feb 03 20:19:51 EET 2021
;; MSG SIZE  rcvd: 102
```

## [1.1.0] - 2021-02-01

### RSpec native support

Added DnsMock helper which can simplify integration with RSpec.

```ruby
# spec/support/config/dns_mock.rb
require 'dns_mock/test_framework/rspec'

RSpec.configure do |config|
  config.include DnsMock::TestFramework::RSpec::Helper
end

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

## [1.0.0] - 2021-01-29

### Configurable record not found behaviour

Added configurable strategy for record not found case. By default it won't raise an exception when DNS record not found in mocked records dictionary:

```ruby
DnsMock.start_server(port: 5300)
```

```bash
dig @localhost -p 5300 A example.com
```

```
; <<>> DiG 9.10.6 <<>> @localhost -p 5300 A example.com
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 38632
;; flags: rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;example.com.			IN	A

;; Query time: 0 msec
;; SERVER: 127.0.0.1#5300(127.0.0.1)
;; WHEN: Fri Jan 29 08:21:30 EET 2021
;; MSG SIZE  rcvd: 40
```

If you want raise an exception when record not found, just start `DnsMock` with `exception_if_not_found: true` option:

```ruby
DnsMock.start_server(exception_if_not_found: true)
```

### Changed

- Updated `DnsMock.start_server`
- Updated `DnsMock::Server`
- Updated `DnsMock::Response::Message`
- Updated `DnsMock::Response::Answer`
- Updated gem version, readme

## [0.2.1] - 2021-01-27

### Fixed RDNS lookup representation

Fixed RDNS lookup representatin for IP address in PTR record feature.

## [0.2.0] - 2021-01-26

### PTR record support

Added ability to mock PTR records. Please note, you can define host address without RDNS lookup prefix (`.in-addr.arpa`). `DnsMock` will do it for you.

```ruby
records = {
  '1.1.1.1' => {
    ptr: %w[domain_1.com domain_2.com]
  }
}

DnsMock.start_server(records: records)
```

```bash
dig @localhost -p 5300 -x 1.1.1.1
```

```
; <<>> DiG 9.10.6 <<>> @localhost -p 5300 -x 1.1.1.1
; (2 servers found)

;; ANSWER SECTION:
1.1.1.1.in-addr.arpa.	1	IN	PTR	domain_1.com.
1.1.1.1.in-addr.arpa.	1	IN	PTR	domain_2.com.

;; Query time: 0 msec
;; SERVER: 127.0.0.1#5300(127.0.0.1)
;; WHEN: Mon Jan 25 19:58:39 EET 2021
;; MSG SIZE  rcvd: 98
```

## [0.1.0] - 2021-01-19

### First release

Implemented first version of `DnsMock`. Thanks [@le0pard](https://github.com/le0pard) for idea & support 🚀
