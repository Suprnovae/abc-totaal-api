require 'spec_helper'

RSpec.describe Basic::Models::Admin, type: :model do
  before(:each) { described_class.collection.drop }
  #after(:each) { described_class.collection.drop }

  let(:god) { {
      name: 'God',
      email: 'god@example.com',
      secret: 'theydontletmedowhatiwant'
  } }

  it 'checks passwords' do
    expect(described_class.create(god).persisted?).to eq(true)
    god_creds = [god[:email], god[:secret]]
    expect(described_class.authenticates_with?(*god_creds)).to eq(true)
    expect(described_class.authenticates_with?(god[:email], 'blah')).to eq(false)
  end

  it 'has multiple reports' do
    new_god = god
    acme_data = {organization: 'Acme Corp', comment: 'Week Reports', data: []}
    test_data= {organization: 'Looney Enterprises', comment: 'IO', data: []}
    new_god[:reports] = [ Basic::Models::Report.new(acme_data) ]
    expect((stored = described_class.create(god)).persisted?).to eq(true)
    expect(stored.reports.count).to eq(1)
    stored.reports.create(test_data)
    expect(stored.reports.count).to eq(2)
  end

  it 'produces login tokens' do
    expect((stored = described_class.create(god)).persisted?).to eq(true)
    expect{ stored.produce_token }.to change{ stored.tokens.count }.from(0).to(1)
  end

  it 'destroys login token after TTL expiration' do
    #skip 'difficult to test since mongod may only perform purge in another 60s'
    expect((stored = described_class.create(god)).persisted?).to eq(true)
    ttl = 2
    token = stored.produce_token(ttl)
    sleep ttl+62 # mongod cleans up in 60 second increments
    expect{ stored.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)

    puts "token id is #{token.id}"
  end
end
