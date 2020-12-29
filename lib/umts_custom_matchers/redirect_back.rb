require 'rspec/rails/matchers'

module UmtsCustomMatchers
  class RedirectBack
    MATCHER_MODULE = RSpec::Rails::Matchers
    STATUS_CODE_MATCHER = MATCHER_MODULE::HaveHttpStatus::GenericStatus
    REDIRECT_PATH_MATCHER = MATCHER_MODULE::RedirectTo::RedirectTo

    ALLOWED_REQUEST_TYPES = [ActionController::TestRequest].freeze
    ALLOWED_RESPONSE_TYPES = [ActionController::TestResponse].freeze

    def initialize(scope)
      @scope = scope
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
    def matches?(code)
      path = 'http://test.host/redirect'

      unless @scope.respond_to?(:request) && @scope.respond_to?(:response)
        fail_spec_type and return false
      end
      unless ALLOWED_REQUEST_TYPES.include? @scope.request.class
        fail_request_type and return false
      end
      unless ALLOWED_RESPONSE_TYPES.include? @scope.response.class
        fail_response_type and return false
      end
      @scope.request.env['HTTP_REFERER'] ||= path
      unless code.is_a? Proc
        fail_input_type code and return false
      end
      code.call
      @response = @scope.response
      status_matcher = STATUS_CODE_MATCHER.new :redirect
      unless status_matcher.matches? @response
        fail_status_code status_matcher and return false
      end
      path_matcher = REDIRECT_PATH_MATCHER.new @scope, path
      unless path_matcher.matches? @response
        fail_redirect_path path_matcher and return false
      end
      true
    end

    def failure_message
      @message
    end

    def failure_message_when_negated
      'expected response not to redirect back, but did'
    end

    def supports_block_expectations?
      true
    end

    private

    def fail_input_type(input)
      @message =
        "expected block argument, but received #{input.class}"
    end

    def fail_redirect_path(matcher)
      @message = matcher.failure_message
    end

    def fail_request_type
      @message = "expected test request to be one of: \
                  #{ALLOWED_REQUEST_TYPES.join ', '}; \
                  but was #{@scope.request.class}"
    end

    def fail_response_type
      @message = "expected test response to be one of: \
                  #{ALLOWED_RESPONSE_TYPES.join ', '}; \
                  but was #{@scope.response.class}"
    end

    def fail_spec_type
      @message = 'The redirect_back matcher is only valid for controller specs.'
    end

    def fail_status_code(matcher)
      @message = matcher.failure_message
    end
  end

  def redirect_back
    RedirectBack.new self
  end
end
