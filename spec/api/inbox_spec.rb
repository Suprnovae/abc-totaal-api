require 'spec_helper'
require 'json'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end

  before(:each) {
    Basic::Models::Report.destroy_all
  }

  context 'POST e-mail hook without attachment' do
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
      post '/hooks/mailgun/report', params
      expect(JSON.parse(last_response.body)["error"]).to include(/[a|A]ttachment required/)
    end
  end

  context 'POST e-mail hook with invalid attachments' do
    let(:params) {
      params = {
        'recipient': 'api@example.com',
        'sender': 'wouter@example.com',
        'from': 'Wouter <wouter@example.com>',
        'subject': 'ACME Corp',
        'body-plain': 'Nieuwe cijfers',
        'attachment-count': 3,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/reports/starkindustries.csv'),
        'attachment-2': Rack::Test::UploadedFile.new('spec/fixtures/reports/Gekko & Co.csv'),
        'attachment-3': Rack::Test::UploadedFile.new('spec/fixtures/reports/dummycsv'),
        'attachment-4': Rack::Test::UploadedFile.new('spec/fixtures/reports/dummycsv'),
      }
    }

    it 'fails on account of an attachment being required' do
      expect { post '/hooks/mailgun/report', params }.to change{ Basic::Models::Report.count }.by(2)
      expect(last_response).to be_created
    end
  end

  context 'POST email with single attachment' do
    let(:params) {
      params = {
        'recipient': 'api@example.com',
        'sender': 'wouter@example.com',
        'from': 'Wouter <wouter@example.com>',
        'subject': 'ACME Corp',
        'body-plain': 'Nieuwe cijfers',
        'attachment-count': 1,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/reports/acmeinc.csv')
      }
    }

    it 'succeeds' do
      post '/hooks/mailgun/report', params
      expect(last_response).to be_created

      post '/hooks/mailgun/report', params
      expect(last_response).to be_ok
    end
  end

  context 'POST email with multiple attachments' do
    let(:params) {
      params = {
        'recipient': 'api@example.com',
        'sender': 'wouter@example.com',
        'from': 'Wouter <wouter@example.com>',
        'subject': 'ACME Corp',
        'body-plain': 'Nieuwe cijfers',
        'attachment-count': 2,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/reports/wonka.csv'),
        'attachment-2': Rack::Test::UploadedFile.new('spec/fixtures/reports/duff.csv'),
      }
    }

    it 'succeeds' do
      expect { post '/hooks/mailgun/report', params }.to change{ Basic::Models::Report.count }.by(2)
      expect(last_response).to be_created

      expect { post '/hooks/mailgun/report', params }.to change{ Basic::Models::Report.count }.by(0)
      expect(last_response).to be_ok
    end
  end

  context 'POST email with multiple attachments' do
    let(:params) {
      params = {
        'recipient': 'api@example.com',
        'sender': 'wouter@example.com',
        'from': 'Wouter <wouter@example.com>',
        'subject': 'ACME Corp',
        'body-plain': 'Nieuwe cijfers',
        'attachment-count': 2,
        'attachment-1': Rack::Test::UploadedFile.new('spec/fixtures/reports/wonka.csv'),
        'attachment-2': Rack::Test::UploadedFile.new('spec/fixtures/reports/duff.csv'),
      }
    }

    it 'succeeds' do
      expect { post '/hooks/mailgun/report', params }.to change{ Basic::Models::Report.count }.by(2)
      expect(last_response).to be_created

      expect { post '/hooks/mailgun/report', params }.to change{ Basic::Models::Report.count }.by(0)
      expect(last_response).to be_ok
    end
  end
end
