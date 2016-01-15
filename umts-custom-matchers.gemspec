# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'umts-custom-matchers/version'

Gem::Specification.new do |spec|
  spec.name          = 'umts-custom-matchers'
  spec.version       = UmtsCustomMatchers::VERSION
  spec.authors       = ['UMass Transit Services']
  spec.email         = ['transit-it@admin.umass.edu']

  spec.summary       = "Custom RSpec Rails-related matcher, used for UMass
                          Transit's internal Rails development process."
  spec.homepage      = 'https://github.com/umts/custom-matchers'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rspec-rails'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
