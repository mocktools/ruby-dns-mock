# Development environment guide

## Preparing

Clone `dns_mock` repository:

```bash
git clone https://github.com/mocktools/ruby-dns-mock.git
cd  ruby-dns-mock
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.1.1' > .ruby-version
cp .circleci/gemspec_latest dns_mock.gemspec
```

## Commiting

Commit your changes excluding `.ruby-version`, `dns_mock.gemspec`

```bash
git add . ':!.ruby-version' ':!dns_mock.gemspec'
git commit -m 'Your new awesome dns_mock feature'
```
