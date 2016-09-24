require 'spec_helper'

RSpec.describe Basic::Ability::Attachable do
  include Basic::Ability::Attachable

  it 'extracts all report entries' do
    extract_report_from(File.open("spec/fixtures/report.csv")).each do |i|
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
    extract = extract_users_from(File.open("spec/fixtures/users.csv"))
  end

  it 'fails when handles are missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/user_without_handle.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end

  it 'fails when secrets are missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/user_without_secret.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end

  it 'fails when reports are missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/user_without_report.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end

  it 'fails when secrets column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_secret_col.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end

  it 'fails when handles column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_handles_col.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end

  it 'fails when handles column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_handles_col.csv"))
    }.to raise_error(Basic::Ability::Attachable::IncompleteAttachmentException)
  end
end
