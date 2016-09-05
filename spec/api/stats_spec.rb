require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  context 'stats GET ' do
    it '/version succeeds' do
      get '/version'
      expect(last_response.status).to eq(200)
    end

    it '/stats displays record count' do
      get '/stats'
      expect(last_response.status).to eq(200)
      p last_response
    end
  end
end
