# frozen_string_literal: true

require_relative 'lib/dns_mock/version'

Gem::Specification.new do |spec|
  spec.name          = 'dns_mock'
  spec.version       = DnsMock::VERSION
  spec.authors       = ['Vladislav Trotsenko']
  spec.email         = %w[admin@bestweb.com.ua]

  spec.summary       = %(dns_mock)
  spec.description   = %(💎 Ruby DNS mock. Mimic any DNS records for your test environment and even more.)

  spec.homepage      = 'https://github.com/mocktools/ruby-dns-mock'
  spec.license       = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://github.com/mocktools/ruby-dns-mock',
    'changelog_uri' => 'https://github.com/mocktools/ruby-dns-mock/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/mocktools/ruby-dns-mock',
    'documentation_uri' => 'https://github.com/mocktools/ruby-dns-mock/blob/master/README.md',
    'bug_tracker_uri' => 'https://github.com/mocktools/ruby-dns-mock/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|dns_mock.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'simpleidn', '~> 0.2.1'

  spec.add_development_dependency 'ffaker', '~> 2.21'
  spec.add_development_dependency 'net-ftp', '~> 0.2.0' if ::Gem::Version.new(::RUBY_VERSION) >= ::Gem::Version.new('3.1.0')
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rspec-dns', '~> 0.1.8'
end
