RSpec.describe Basic::Models::Token, type: :model do
  before(:each) { described_class.collection.drop }

  it 'validates the presence of a token value' do
    expect { described_class.create({ }) }.to_not raise_error
  end
end
