require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  context 'POST basic email' do
    it 'suceeds' do
      params =  {
        'recipient': 'machine@example.com',
        'sender': 'jane@doe.tld',
        'from': 'jane@doe.tld',
        'subject': 'Test mail',
        'body-plain': 'Do you get this now?',
      }
      post '/inbox', params
    end
  end
end
