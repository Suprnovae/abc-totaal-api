require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  let(:password) { 'yoda@jedi.order' }
  let(:user_details) { {
    name: 'Yoda',
    email: password,
    secret: 'Entry, I request!'
  } }
  let(:report_details) { {
    organization: 'Jedi Order',
    shortname: 'jedi',
    comment: 'Keepers of the peace in the galaxy',
    data: [
      { actual: 12, predicted: 14 }
    ]
  } }
  let(:user) { Basic::Models::User.create user_details }
  let(:token) { user.produce_token(100) }
  let(:expired_token) { user.produce_token(0) }
  let(:report) { user.reports.create report_details }

  before(:all) do
    [Basic::Models::User, Basic::Models::Report].each do |model|
      model.collection.drop
    end
  end

  context 'GET /reports unauthenticated' do
    it 'is not authorized' do
      get '/reports'
      expect(last_response.status).to eq(401)
    end
  end

  context 'GET /reports with expired credentials' do
    before(:each) do
      header 'Authorization', "Bearer #{expired_token.value}"
    end

    it 'is not authorized' do
      get '/reports'
      expect(last_response.status).to eq(401)
    end
  end

  context 'GET /reports authenticated' do
    before(:each) do
      header 'Authorization', "Bearer #{token.value}"
    end

    it 'succeeds' do
      get '/reports'
      expect(last_response.status).to eq(200)
    end

    it 'contains the data' do
      skip
      get '/reports'
      payload = JSON.parse(last_response.body)
      expect(payload).to_not be_empty
      expect(payload.first).to have_key('shortname')
      expect(payload.first).to have_key('organization')
      expect(payload.first).to have_key('comment')
      expect(payload.first).to have_key('data')
    end
  end
end


