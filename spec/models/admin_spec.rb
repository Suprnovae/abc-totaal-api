require 'spec_helper'

RSpec.describe Basic::Models::Admin, type: :model do
  let(:admin) { described_class }
  let(:details) { {
      name: 'God',
      email: 'god@example.com',
      secret: 'theydontletmedowhatiwant'
  } }
  let(:bogey) { described_class.new(details) }

  after(:each) { bogey.destroy! }

  it 'demands passwords' do
    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted
    bogey_creds = [details[:email], details[:secret]]
    expect(admin.authenticates_with?(*bogey_creds)).to eq(true)
    expect(admin.authenticates_with?(bogey[:email], 'blah')).to eq(false)
  end

  it 'has multiple reports' do
    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted

    acme_data = {organization: 'Acme Corp', comment: 'Week Reports', data: []}
    test_data= {organization: 'Looney Enterprises', comment: 'IO', data: []}

    bogey.reports.create(acme_data)
    expect(bogey.reports.count).to eq(1)
    bogey.reports.create(test_data)
    expect(bogey.reports.count).to eq(2)
  end

  it 'produces login tokens' do
    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted
    expect{ bogey.produce_token }.to change{ bogey.tokens.count }.from(0).to(1)
  end

  it 'destroys login token after TTL expiration' do
    skip 'difficult to test since mongod may only perform purge in another 60s'
    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted

    ttl = 2
    token = bogey.produce_token(ttl)
    sleep ttl+62 # mongod cleans up in 60 second increments
    expect{ bogey.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)

    puts "token id is #{token.id}"
  end
end
