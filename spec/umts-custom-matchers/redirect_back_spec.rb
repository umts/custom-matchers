require 'spec_helper'
require 'pry-byebug'

class TestController < ActionController::Base
  def _routes
    TestApplication.routes
  end

  def no_redirect
    render nothing: true
  end

  def redirect
    redirect_to :back
  end
end

TestApplication.routes.draw do
  get '/test/no_redirect', to: 'test#no_redirect'
  get '/test/redirect', to: 'test#redirect'
end

describe TestController, type: :controller do
  describe 'GET #no_redirect' do
    it 'does not redirect back' do
      expect { get :no_redirect }.not_to redirect_back
    end
  end

  describe 'GET #redirect' do
    it 'redirects back' do
      expect { get :redirect }.to redirect_back
    end
  end
end
