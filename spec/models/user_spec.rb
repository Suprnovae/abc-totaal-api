require 'spec_helper'

RSpec.describe Basic::Models::User, type: :model do
  let(:user) { described_class }
  let(:details) { {
      name: 'Wile E. Coyote',
      email: 'coyote@acme.corp',
      secret: 'hopeigetlucky'
  } }
  let(:bogey) { described_class.new(details) }

  after(:each) { bogey.destroy }

  it 'checks passwords' do

    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted
    bogey_creds = [details[:email], details[:secret]]
    expect(user.authenticates_with?(*bogey_creds)).to eq(true)
    expect(user.authenticates_with?(details[:email], 'blah')).to eq(false)
  end

  it 'produces login tokens' do
    expect(bogey.save).to eq(true)
    expect(bogey).to be_persisted
    expect{ bogey.produce_token }.to change{ bogey.tokens.count }.from(0).to(1)
  end
end
