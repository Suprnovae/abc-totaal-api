require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  before(:all) do
    [Basic::Models::User, Basic::Models::Report].each do |model|
      model.collection.drop
    end

    Basic::Models::User.create(
      name: 'Yoda',
      email: 'yoda@jedi.order',
      secret: 'Entry, I request!',
      report_id: Basic::Models::Report.create(
        organization: 'Jedi Order',
        shortname: 'jedi',
        comment: 'Keepers of the peace in the galaxy',
        data: [
          { actual: 12, predicted: 14 }
        ]
      ).id
    )
  end

  context 'GET /overview unauthenticated' do
    it 'is not authorized' do
      get '/overview'
      expect(last_response.status).to eq(401)
    end
  end

  context 'GET /overview authenticated' do
    before(:each) do
      basic_authorize 'yoda@jedi.order', 'Entry, I request!'
    end

    it 'succeeds' do
      get '/overview'
      expect(last_response.status).to eq(200)
    end

    it 'contains the data' do
      get '/overview'
      payload = JSON.parse(last_response.body)
      expect(payload).to have_key('shortname')
      expect(payload).to have_key('organization')
      expect(payload).to have_key('comment')
      expect(payload).to have_key('data')
    end
  end
end

