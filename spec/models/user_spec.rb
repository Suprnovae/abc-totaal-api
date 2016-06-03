require 'spec_helper'

RSpec.describe Basic::Models::User, type: :model do
  before(:each) { described_class.collection.drop }
  let(:wiley) { {
      name: 'Wile E. Coyote',
      email: 'coyote@acme.corp',
      secret: 'hopeigetlucky'
  } }

  it 'checks passwords' do
    expect(described_class.create(wiley).persisted?).to eq(true)
    wiley_creds = [wiley[:email], wiley[:secret]]
    expect(described_class.authenticates_with?(*wiley_creds)).to eq(true)
    expect(described_class.authenticates_with?(wiley[:email], 'blah')).to eq(false)
  end
end
