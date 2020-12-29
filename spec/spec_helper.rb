require 'rails/all'
require 'rspec/rails'
require 'simplecov'

SimpleCov.start { refuse_coverage_drop }

require 'umts-custom-matchers'
include UmtsCustomMatchers
