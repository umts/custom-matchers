require 'rails/all'
require 'rspec/rails'
require 'simplecov'

SimpleCov.start do
  refuse_coverage_drop
end

require 'umts-custom-matchers'
include UmtsCustomMatchers

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

class TestApplication < Rails::Application
  config.secret_key_base = 'A secret, secret key'
end
