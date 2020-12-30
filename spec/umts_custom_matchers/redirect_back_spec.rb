# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UmtsCustomMatchers::RedirectBack do
  subject(:matcher) { described_class.new scope }

  let(:scope) { double }
  let(:controller_class) { ActionController::Base }
  let(:request_class) { ActionController::TestRequest }
  let(:response_class) { ActionDispatch::TestResponse }
  let(:mock_request) do
    if request_class.method(:create).arity == 0
      request_class.create
    else
      request_class.create(controller_class)
    end
  end
  let(:input) { :anything } # like, literally anything for now
  let(:result) { matcher.matches? input }

  it 'supports block expectations' do
    expect(matcher.supports_block_expectations?).to be true
  end

  it 'has the correct negation failure message' do
    expect(matcher.failure_message_when_negated)
      .to include 'expected', 'not to redirect back', 'but did'
  end

  it 'can be invoked with the helper method' do
    obj = Class.new { include UmtsCustomMatchers }.new
    expect(obj.redirect_back).to be_a described_class
  end

  context 'example scope has response but no request' do
    it 'fails with expected message' do
      allow(scope).to receive(:response).and_return response_class.new
      expect(result).to be false
      expect(matcher.failure_message).to include 'only valid for controller specs'
    end
  end

  context 'example scope has request but no response' do
    it 'fails with expected message' do
      allow(scope).to receive(:request).and_return mock_request
      expect(result).to be false
      expect(matcher.failure_message).to include 'only valid for controller specs'
    end
  end

  context 'example scope has request and response' do
    before :each do
      allow(scope).to receive(:request).and_return request
      allow(scope).to receive(:response).and_return response
    end
    context 'request is not an ActionController::TestRequest' do
      let(:request_class) { Class.new }
      let(:request) { request_class.new }
      let(:response) { response_class.new }
      it 'fails with expected message' do
        expect(result).to be false
        expect(matcher.failure_message).to include 'expected test request to be',
                                                   'ActionController::TestRequest',
                                                   "but was #{request_class}"
      end
    end
    context 'response is not an ActionDispatch::TestResponse' do
      let(:request) { mock_request }
      let(:response_class) { Class.new }
      let(:response) { response_class.new }
      it 'fails with expected message' do
        expect(result).to be false
        expect(matcher.failure_message).to include 'expected test response to be',
                                                   'ActionDispatch::TestResponse',
                                                   "but was #{response_class}"
      end
    end
    context 'request and response have correct types' do
      let(:request) { mock_request }
      let(:response) { response_class.new }
      context 'input is not a Proc' do
        let(:input) { :a_symbol }
        it 'fails with expected message' do
          expect(result).to be false
          expect(matcher.failure_message).to include 'expected block argument',
                                                     'but received Symbol'
        end
      end
      context 'input is a Proc' do
        let(:input) { proc { :hello } }
        context 'response has incorrect status code' do
          let(:response) { response_class.new 200 }
          it 'fails with expected message' do
            expect(result).to be false
            expect(matcher.failure_message).to include 'expected the response',
                                                       'to have a redirect status code',
                                                       'but it was 200'
          end
        end
        context 'response has correct status code' do
          let(:response) { response_class.new 302 }
          context 'response does not redirect back to given URL' do
            it 'fails with expected message' do
              allow(scope).to receive(:assert_redirected_to).and_raise Minitest::Assertion
              expect(result).to be false
            end
          end
          context 'response redirects back to given URL' do
            it 'passes' do
              allow(scope).to receive(:assert_redirected_to).and_return true
              expect(result).to be true
            end
          end
        end
      end
    end
  end
end
