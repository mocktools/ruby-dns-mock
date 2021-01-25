# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
