require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  context 'GET /version' do
    it 'returns something' do
      get '/version'
      expect(last_response.status).to eq(200)
    end
  end
end
