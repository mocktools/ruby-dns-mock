# frozen_string_literal: true

if ::RUBY_VERSION.eql?('2.5.0')
  require 'simplecov'

  SimpleCov.minimum_coverage(100)
  SimpleCov.start
end
