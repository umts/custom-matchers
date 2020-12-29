require 'action_controller/railtie'
require 'rspec/rails'
require 'simplecov'

SimpleCov.start { refuse_coverage_drop }

require 'umts_custom_matchers'
include UmtsCustomMatchers
