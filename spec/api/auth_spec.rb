require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  let(:password) { 'Entry, I request!' }
  let(:details) { {
    name: 'Yoda',
    email: 'yoda@jedi.order',
    secret: password
  } }
  let(:user) { 
    Basic::Models::User.create details
  }

  before(:all) do
    [Basic::Models::User, Basic::Models::Admin, Basic::Models::Token].each do |model|
      model.collection.drop
    end
  end

  after(:all) do
    [Basic::Models::User, Basic::Models::Admin, Basic::Models::Token].each do |model|
      model.destroy_all
    end
  end

  context 'GET /auth/user' do
    it 'is not authorized' do
      get '/auth/user'
      expect(last_response.status).to eq(401)
    end

    it 'receives a valid token' do
      basic_authorize user.email, password
      get '/auth/user'
      expect(JSON.parse(last_response.body)).to include('token')
      user.destroy
    end
  end

  context 'GET /auth/admin' do
    it 'is not authorized'
    it 'receives a valid token'
  end
end
