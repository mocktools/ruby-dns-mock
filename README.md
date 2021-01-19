# DnsMock

```ruby
# Example of mocked DNS records
records = {
  'example.com' => {
    a: %w[1.2.3.4],
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

dns_mock_server = DnsMock.start_server(records: records)
dns_mock_server.port
dns_mock_server.assign_mocks(records)
dns_mock_server.reset_mocks!
dns_mock_server.stop!

DnsMock.running_servers
DnsMock.stop_running_servers!
```
