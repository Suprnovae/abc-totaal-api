require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  context 'GET /overview unauthenticated' do
    it 'is not authorized' do
      get '/overview'
      expect(last_response.status).to eq(401)
    end
  end

  context 'GET /overview authenticated' do
    before(:each) do
      basic_authorize 'yoda', 'entryirequest'
    end

    it 'succeeds' do
      get '/overview'
      expect(last_response.status).to eq(200)
    end
  end
end

