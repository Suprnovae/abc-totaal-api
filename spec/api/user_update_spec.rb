require 'spec_helper'
require 'json'

describe Basic::Hooks::UserUpdate do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  before(:each) {
    Basic::Models::User.destroy_all
    Basic::Models::Report.destroy_all
  }

  context 'POST user hook without attachment' do
    let(:params) {
      {
        'recipient': 'machine@example.com',
        'sender': 'jane@doe.tld',
        'from': 'jane@doe.tld',
        'subject': 'Test mail',
        'body-plain': 'Do you get this now?',
      }
    }

    it 'fails on account of an attachment being required' do
      post '/hooks/mailgun/user', params
      expect(last_response).to_not be_ok
      expect(JSON.parse(last_response.body)["error"]).to include(/[a|A]ttachments? required/)
    end
  end

  context 'POST user hook without attachment' do
    let(:params) {
      {
        'recipient': 'machine@example.com',
        'sender': 'jane@doe.tld',
        'from': 'jane@doe.tld',
        'subject': 'Test mail',
        'body-plain': 'Do you get this now?',
        'attachment-count': 2,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/users/starkindustries.csv'),
        'attachment-2': Rack::Test::UploadedFile.new('spec/fixtures/users/wonka.csv'),
      }
    }

    it 'creates expected user records' do
      Basic::Models::Report.create({
        shortname: 'starkindustries',
        organization: 'Stark Industries',
        comment: 'Where is Ironman?',
        data: []
      })
      Basic::Models::Report.create({
        shortname: 'wonka',
        organization: 'Willy Wonka Choco Factory',
        comment: 'We also make coco!',
        data: []
      })
      expect {
        post '/hooks/mailgun/user', params
      }.to change{ Basic::Models::User.count }.by(5)
      expect(last_response).to be_ok
    end
  end

  context 'POST user hook with attachment for missing report' do
    let(:params) {
      {
        'recipient': 'machine@example.com',
        'sender': 'jane@doe.tld',
        'from': 'jane@doe.tld',
        'subject': 'Test mail',
        'body-plain': 'Do you get this now?',
        'attachment-count': 2,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/users/starkindustries.csv'),
        'attachment-2': Rack::Test::UploadedFile.new('spec/fixtures/users/wonka.csv'),
      }
    }
    it 'fails if a report is missing' do
      Basic::Models::Report.create({
        shortname: 'acme',
        organization: 'Acme Broken Traps Industries',
        comment: 'Meek Meek!',
        data: []
      })
      post '/hooks/mailgun/user', params
      expect(last_response).to_not be_ok
    end
  end
end
