require 'spec_helper'

RSpec.describe Basic::Models::Admin, type: :model do
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

  it 'has multiple reports' do
    new_wiley = wiley
    acme_data = {organization: 'Acme Corp', comment: 'Week Reports', data: []}
    test_data= {organization: 'Looney Enterprises', comment: 'IO', data: []}
    new_wiley[:reports] = [ Basic::Models::Report.new(acme_data) ]
    expect((stored = described_class.create(wiley)).persisted?).to eq(true)
    expect(stored.reports.count).to eq(1)
    stored.reports.create(test_data)
    expect(stored.reports.count).to eq(2)
  end
end
