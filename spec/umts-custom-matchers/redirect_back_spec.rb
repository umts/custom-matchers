require 'spec_helper'
require 'pry-byebug'

describe RedirectBack do
  let(:scope) { double }
  subject(:matcher) { RedirectBack.new scope }

  it 'supports block expectations' do
    expect(matcher.supports_block_expectations?).to be true
  end

  it 'has the correct negation failure message' do
    expect(matcher.failure_message_when_negated)
      .to include 'expected', 'not to redirect back', 'but did'
  end

  it 'can be invoked with the helper method' do
    expect(redirect_back).to be_a RedirectBack
  end

  context 'example scope has response but no request' do
    it 'fails with expected message' do
      allow(scope).to receive(:response).and_return ActionController::TestResponse.new
      expect(matcher.matches? :anything).to be false
      expect(matcher.failure_message).to include 'only valid for controller specs'
    end
  end

  context 'example scope has request but no response' do
    it 'fails with expected message' do
      allow(scope).to receive(:request).and_return ActionController::TestRequest.new
      expect(matcher.matches? :anything).to be false
      expect(matcher.failure_message).to include 'only valid for controller specs'
    end
  end

  context 'example scope has request and response' do
    before :each do
      allow(scope).to receive(:request).and_return request
      allow(scope).to receive(:response).and_return response
    end
    context 'request is not an ActionController::TestRequest' do
      let(:request) { ActionDispatch::Request.new({}) }
      let(:response) { ActionController::TestResponse.new }
      it 'fails with expected message' do
        expect(matcher.matches? :anything).to be false
        expect(matcher.failure_message).to include 'expected test request to be',
                                                   'ActionController::TestRequest',
                                                   'but was ActionDispatch::Request'
      end
    end
    context 'response is not an ActionController::TestResponse' do
      let(:request) { ActionController::TestRequest.new }
      let(:response) { ActionDispatch::Response.new }
      it 'fails with expected message' do
        expect(matcher.matches? :anything).to be false
        expect(matcher.failure_message).to include 'expected test response to be',
                                                   'ActionController::TestResponse',
                                                   'but was ActionDispatch::Response'
      end
    end
    context 'request and response have correct types' do
      let(:request) { ActionController::TestRequest.new }
      let(:response) { ActionController::TestResponse.new }
      context 'input is not a Proc' do
        it 'fails with expected message' do
          expect(matcher.matches? :a_symbol).to be false
          expect(matcher.failure_message).to include 'expected block argument',
                                                     'but received Symbol'
        end
      end
      context 'input is a Proc' do
        let(:input) { Proc.new { :hello } }
        context 'response has incorrect status code' do
          let(:response) { ActionController::TestResponse.new 200 }
          it 'fails with expected message' do
            expect(matcher.matches? input).to be false
            expect(matcher.failure_message).to include 'expected the response',
                                                       'to have a redirect status code',
                                                       'but it was 200'
          end
        end
        context 'response has correct status code' do
          context 'response does not redirect back to given URL' do
            let(:response) { ActionController::TestResponse.new 302 }
            it 'fails with expected message' do
              allow(scope).to receive(:assert_redirected_to).and_raise Minitest::Assertion
              expect(matcher.matches? input).to be false
            end
          end
          context 'response redirects back to given URL' do
            let(:response) { ActionController::TestResponse.new 302 }
            it 'passes' do
              allow(scope).to receive(:assert_redirected_to).and_return true
              expect(matcher.matches? input).to be true
            end
          end
        end
      end
    end
  end
end
