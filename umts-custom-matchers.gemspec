# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'umts_custom_matchers/version'

RAKE = Gem::Dependency.new('rake', '~> 13.0')
if File.basename($0) == 'bundle' && !ARGV.include?('exec')
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install(RAKE)
end
require 'rake'

Gem::Specification.new do |spec|
  spec.name                  = 'umts-custom-matchers'
  spec.version               = UmtsCustomMatchers::VERSION
  spec.authors               = ['UMass Transit Services']
  spec.email                 = ['transit-it@admin.umass.edu']

  spec.summary               = <<-SUMMARY.gsub(/[[:space:]]+/, ' ').strip
                               Custom RSpec Rails-related matcher, used for UMass
                               Transit's internal Rails development process.
  SUMMARY
  spec.homepage              = 'https://github.com/umts/custom-matchers'
  spec.license               = 'MIT'
  spec.post_install_message  = <<-PIM.gsub(/[[:space:]]+/, ' ').strip
                               The require location of this gem's libraries has
                               been changed to reflect better ruby conventions.
                               Change any instance of
                               `require 'umts-custom-matchers' to
                               `require 'umts_custom_matchers'
  PIM

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  unless spec.respond_to?(:metadata)
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files                 = FileList['lib/**/*.rb', 'README*', 'LICENSE*'].to_a &
                               `git ls-files -z`.split("\x0")
  spec.require_paths         = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'rspec-rails', '>= 3.0', '<= 6.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency RAKE.name, RAKE.requirements_list
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
