require 'spec_helper'

RSpec.describe Basic::Models::Report, type: :model do
  before(:each) { described_class.collection.drop }

  let(:acme_report) { {
    shortname: 'acme',
    organization: 'Acme Corp',
    comment: 'Just an update',
    data: []
  } }

  it { should have_field :organization }
  it { should have_field :comment }
  it { should have_field :updated_at }
  it { should have_field :data }
  it { expect(described_class.create!(acme_report).persisted?).to eq(true) }
end
