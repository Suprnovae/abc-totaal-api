require 'spec_helper'

RSpec.describe Basic::Models::User, type: :model do
  before(:each) { described_class.collection.drop }

  it 'should add wiley' do
    #skip
    p described_class.create(
      name: 'Wile E. Coyote',
      email: 'coyote@acme.corp',
    )
  end
end
