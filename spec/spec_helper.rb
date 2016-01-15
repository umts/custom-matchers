$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rails/all'
require 'rspec/rails'
require 'umts-custom-matchers'
include UmtsCustomMatchers

class TestApplication < Rails::Application
  config.secret_key_base = 'A secret, secret key'
end
