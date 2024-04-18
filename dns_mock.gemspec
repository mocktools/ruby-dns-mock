# frozen_string_literal: true

require_relative 'lib/dns_mock/version'

Gem::Specification.new do |spec|
  spec.name          = 'dns_mock'
  spec.version       = DnsMock::VERSION
  spec.authors       = ['Vladislav Trotsenko']
  spec.email         = %w[admin@bestweb.com.ua]

  spec.summary       = %(💎 Ruby DNS mock. Mimic any DNS records for your test environment)
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

  current_ruby_version = ::Gem::Version.new(::RUBY_VERSION)
  ffaker_version = current_ruby_version >= ::Gem::Version.new('3.0.0') ? '~> 2.23' : '~> 2.21'

  spec.required_ruby_version = '>= 2.5.0'
  spec.files = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(bin|lib)/|.ruby-version|dns_mock.gemspec|LICENSE}) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'simpleidn', '~> 0.2.1'

  spec.add_development_dependency 'ffaker', ffaker_version
  spec.add_development_dependency 'net-ftp', '~> 0.3.4' if current_ruby_version >= ::Gem::Version.new('3.1.0')
  spec.add_development_dependency 'rake', '~> 13.1'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rspec-dns', '~> 0.1.8'
end
