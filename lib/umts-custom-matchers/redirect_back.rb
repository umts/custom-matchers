require 'rspec/rails/matchers'

module UmtsCustomMatchers
  class RedirectBack
    MATCHER_MODULE = RSpec::Rails::Matchers
    STATUS_CODE_MATCHER = MATCHER_MODULE::HaveHttpStatus::GenericStatus
    REDIRECT_PATH_MATCHER = MATCHER_MODULE::RedirectTo::RedirectTo

    def initialize(scope)
      @scope = scope
    end

    def matches?(code)
      path = 'http://test.host/redirect'
      @scope.request.env['HTTP_REFERER'] = path
      return false unless code.is_a? Proc
      code.call
      STATUS_CODE_MATCHER.new(:redirect).matches?(@scope.response) &&
        REDIRECT_PATH_MATCHER.new(@scope, path).matches?(true)
    end

    def supports_block_expectations?
      true
    end
  end

  def redirect_back
    RedirectBack.new self
  end
end
