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
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'fails when secrets are missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/user_without_secret.csv"))
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'fails when reports are missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/user_without_report.csv"))
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'fails when secrets column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_secret_col.csv"))
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'fails when handles column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_handles_col.csv"))
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'fails when handles column is missing' do
    expect {
      extract_users_from(File.open("spec/fixtures/users_without_handles_col.csv"))
    }.to raise_error(IncompleteAttachmentException)
  end

  it 'yields on every CSV attachment' do
    params = {
      'attachment-1' => { name: 'yoda', filename: 'yoda.csv' },
      'attachment-2' => { name: 'jarjar', filename: 'jarjar.csv' },
      'attachment-3' => { name: 'leila', filename: 'leila.csv' },
    }
    args = params.map { |k, v| v }.map.with_index(1) { |v, i| [i, v] }
    expect { |b| for_every_csv_attachment(3, params, &b) }.to yield_successive_args(*args)
  end

  it 'sanitizes names' do
    sanitizations = [
      ['information for you and i', 'information_for_you_and_i'],
      ['Stark Industries', 'stark_industries'],
      ['Do-re-Mi-fa-So', 'do-re-mi-fa-so'],
      ['You & I', 'you_and_i'],
      ['foo@example.com', 'foo_at_example.com'],
      ['x = 12', 'x_is_12'],
      ['Andrew <a@example.com>', 'andrew_a_at_example.com'],
      ['Deep {learning} machine', 'deep_learning_machine'],
      ['~tilde~another~hi', 'tilde_another_hi'],
      ['$var', 'var'],
      ['This is (very) useful... or not', 'this_is_very_useful_or_not'],
      ['are?you?', 'are_you'],
    ]

    sanitizations.map { |c| expect(sanitize(c[0])).to eq(c[1]) }
  end
end
