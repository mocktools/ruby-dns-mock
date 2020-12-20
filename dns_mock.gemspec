# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dns_mock/version'

Gem::Specification.new do |spec|
  spec.name          = 'dns_mock'
  spec.version       = DnsMock::VERSION
  spec.authors       = ['Vladislav Trotsenko']
  spec.email         = ['admin@bestweb.com.ua']

  spec.summary       = %(dns_mock)
  spec.description   = %(Ruby DNS mock)

  spec.homepage      = 'https://github.com/truemail-rb/ruby-dns-mock'
  spec.license       = 'MIT'

  spec.metadata = {
    'homepage_uri' => 'https://truemail-rb.org',
    'changelog_uri' => 'https://github.com/truemail-rb/ruby-dns-mock/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/truemail-rb/ruby-dns-mock',
    'documentation_uri' => 'https://truemail-rb.org/ruby-dns-mock',
    'bug_tracker_uri' => 'https://github.com/truemail-rb/ruby-dns-mock/issues'
  }

  spec.required_ruby_version = '>= 2.5.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'bundler-audit', '~> 0.7.0.1'
  spec.add_development_dependency 'faker', '~> 2.15', '>= 2.15.1'
  spec.add_development_dependency 'fasterer', '~> 0.8.3'
  spec.add_development_dependency 'overcommit', '~> 0.57.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.2'
  spec.add_development_dependency 'reek', '~> 6.0', '>= 6.0.2'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.6', '>= 1.6.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9', '>= 1.9.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.1'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
end
