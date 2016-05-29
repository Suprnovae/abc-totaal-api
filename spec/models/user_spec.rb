require 'spec_helper'

RSpec.describe Basic::Models::User, type: :model do
  it 'should add wiley' do
    #skip
    p described_class.create(
      handle: 'wileycoyote',
      salt: 'somethingdumb'
    )
  end
end
