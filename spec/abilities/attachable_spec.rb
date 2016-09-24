require 'spec_helper'

RSpec.describe Basic::Ability::Attachable do
  include Basic::Ability::Attachable

  it 'extracts all report entries' do
    extract_report_from("spec/fixtures/report.csv").each do |i|
      expect(i).to include(:description)
      expect(i[:description]).to be_a_kind_of(String)
      expect(i).to include(:predicted)
      expect(i[:predicted]).to be_a_kind_of(Integer)
      expect(i).to include(:actual)
      expect(i[:actual]).to be_a_kind_of(Integer)
      expect(i).to include(:tablets)
      expect(i[:tablets]).to be_a_kind_of(Array)
    end
  end

  it 'extract all user credentials' do
    extract = extract_users_from("spec/fixtures/users.csv")
    p extract
  end
end
