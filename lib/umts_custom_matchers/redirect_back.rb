# frozen_string_literal: true

require 'action_controller'
require 'action_controller/test_case'
require 'rspec/rails/matchers'

##
#:nodoc:
module UmtsCustomMatchers
  ##
  # Matcher for redirecting to "back". Asserts that the HTTP response code is
  # a redirect, and also that the `Location` matches the HTTP_REFERER of the
  # request.
  class RedirectBack
    MATCHER_MODULE = RSpec::Rails::Matchers
    STATUS_CODE_MATCHER = MATCHER_MODULE::HaveHttpStatus::GenericStatus
    REDIRECT_PATH_MATCHER = MATCHER_MODULE::RedirectTo::RedirectTo

    ALLOWED_REQUEST_TYPES = [ActionController::TestRequest].freeze
    ALLOWED_RESPONSE_TYPES = [ActionDispatch::TestResponse].freeze

    def initialize(scope)
      @scope = scope
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength

    ##
    # Returns `true` if response is a `302`, and the location matches the `HTTP_REFERER`
    # of the request. `false` otherwise.
    def matches?(code)
      path = 'http://test.host/redirect'
      status_matcher = STATUS_CODE_MATCHER.new :redirect
      path_matcher = REDIRECT_PATH_MATCHER.new @scope, path

      verify_spec_type or return false
      verify_request_type or return false
      verify_response_type or return false
      verify_input_type(code) or return false

      @scope.request.env['HTTP_REFERER'] ||= path
      code.call
      @response = @scope.response

      verify_status_code(status_matcher) or return false
      verify_redirect_path(path_matcher) or return false

      true
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength

    ##
    #:nodoc:
    def failure_message
      @message
    end

    ##
    #:nodoc:
    def failure_message_when_negated
      'expected response not to redirect back, but did'
    end

    ##
    #:nodoc:
    def supports_block_expectations?
      true
    end

    private

    def verify_input_type(input)
      return true if input.is_a? Proc

      @message =
        "expected block argument, but received #{input.class}"
      false
    end

    def verify_redirect_path(matcher)
      return true if matcher.matches? @response

      @message = matcher.failure_message
      false
    end

    def verify_request_type
      return true if ALLOWED_REQUEST_TYPES.include? @scope.request.class

      @message = "expected test request to be one of: \
                  #{ALLOWED_REQUEST_TYPES.join ', '}; \
                  but was #{@scope.request.class}"
      false
    end

    def verify_response_type
      return true if ALLOWED_RESPONSE_TYPES.include? @scope.response.class

      @message = "expected test response to be one of: \
                  #{ALLOWED_RESPONSE_TYPES.join ', '}; \
                  but was #{@scope.response.class}"
      false
    end

    def verify_spec_type
      return true if @scope.respond_to?(:request) && @scope.respond_to?(:response)

      @message = 'The redirect_back matcher is only valid for controller specs.'
      false
    end

    def verify_status_code(matcher)
      return true if matcher.matches? @response

      @message = matcher.failure_message
      false
    end
  end

  ##
  # Wrapper method for `RedirectBack` can be used in examples if `UmtsCustomMatchers`
  # is incuded.
  def redirect_back
    RedirectBack.new self
  end
end
