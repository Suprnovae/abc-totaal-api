require 'spec_helper'

RSpec.describe Basic::Models::Token, type: :model do
  it 'validates the presence of a token value' do
    expect(described_class.create({ })).to_not be_valid
  end

  it 'prevents double storage' do
    word = SecureRandom.hex
    first = described_class.new(value: word)
    second = described_class.new(value: word)

    expect(first).to be_new_record
    expect { first.save! }.to_not raise_error

    expect(second).to be_new_record
    expect { second.save! }.to raise_error /duplicate key/
  end
end
