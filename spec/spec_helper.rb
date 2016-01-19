require 'rails/all'
require 'rspec/rails'
require 'simplecov'
require 'codeclimate-test-reporter'

SimpleCov.start { refuse_coverage_drop }
CodeClimate::TestReporter.start

require 'umts-custom-matchers'
include UmtsCustomMatchers
