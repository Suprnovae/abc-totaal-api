require 'spec_helper'

RSpec.describe Basic::Models::Report, type: :model do
  before(:each) { described_class.collection.drop }

  it { should have_field :organization }
  it { should have_field :comment }
  it { should have_field :updated_at }
  it { should have_field :data }
#  it { p described_class.count }
#  it { p described_class.create!(
#    organization: 'Acme Corp',
#    comment: 'Just an update',
#    data: {}
#  ) }
  #it { p "Everything is #{described_class.all}" }
end
