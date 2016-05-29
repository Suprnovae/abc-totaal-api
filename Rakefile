namespace :db do
  require 'mongoid'
  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
  Mongoid.load! 'config/mongoid.yml'

  desc 'Create indexes for Mongo collections'
  task :create_indexes do
    env = ENV['RAILS_ENV']
    unless env
      puts 'Specify RAILS_ENV' and exit
    end

    [Basic::Models::Report, Basic::Models::User].each do |model|
      puts "Creating indexes for #{model}: #{model.create_indexes}"
    end
  end

  desc 'Remove indexes for Mongo collections'
  task :remove_indexes do
    env = ENV['RAILS_ENV']
    unless env
      puts 'Specify RAILS_ENV' and exit
    end

    [Basic::Models::Report, Basic::Models::User].each do |model|
      puts "Removing indexes for #{model}: #{model.remove_indexes}"
    end
  end

  desc "Create a user given handle and return the token"
  task :create_user, :name, :email, :report_id do |t, args|
    new_user = Basic::Models::User.create(
      email: args[:email],
      name: args[:name],
      report_id: BSON::ObjectId.from_string(args[:report_id])
    )
    p "Created user #{new_user.name} <#{new_user.email}> with report #{new_user.report_id}"
  end

  desc "Update report with given json payload"
  task :update_report, :shortname, :organization, :comment, :payload do |t, args|
    require 'yaml'
    new_report = Basic::Models::Report.create(
      shortname: args[:shortname],
      organization: args[:organization],
      comment: args[:comment],
      data: YAML::load_file(File.join(__dir__, args[:payload]))
    )
    p "Created report #{new_report.id}"
  end
end

