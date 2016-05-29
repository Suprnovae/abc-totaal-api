require 'spec_helper'

RSpec.describe Basic::Models::User, type: :model do
  before(:each) { described_class.collection.drop }

  it 'checks passwords' do
    email = 'coyote@acme.corp'
    secret = 'hopeigetlucky'
    expect(described_class.create(
      name: 'Wile E. Coyote',
      email: email,
      secret: secret 
    ).persisted?).to eq(true)

    expect(described_class.authenticates_with?(email, secret)).to eq(true)
  end
end
