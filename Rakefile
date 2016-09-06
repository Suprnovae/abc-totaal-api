namespace :db do
  require 'mongoid'
  require 'yaml'

  Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
  Mongoid.load! 'config/mongoid.yml'

  models = [
    Basic::Models::Report,
    Basic::Models::User,
    Basic::Models::Admin,
    Basic::Models::Token,
  ]

  desc 'Create indexes for Mongo collections'
  task :create_indexes do
    env = ENV['RACK_ENV']
    puts "RACK_ENV is #{env}"
    unless env
      puts 'Specify RACK_ENV' and exit
    end

    models.each do |model|
      puts "Creating indexes for #{model}: #{model.create_indexes}"
    end
  end

  desc 'Remove indexes for Mongo collections'
  task :remove_indexes do
    env = ENV['RACK_ENV']
    unless env
      puts 'Specify RACK_ENV' and exit
    end

    models.each do |model|
      puts "Removing indexes for #{model}: #{model.remove_indexes}"
    end
  end

  desc "Create a user given handle and return the token"
  task :create_user, :name, :email, :report_id do |t, args|
    new_user = Basic::Models::User.create(
      email: args[:email],
      name: args[:name],
      secret: args[:secret],
      report_id: BSON::ObjectId.from_string(args[:report_id])
    )
    p "Created user #{new_user.name} <#{new_user.email}> with report #{new_user.report_id}"
  end

  desc "Change password"
  task :update_pass, :email, :secret do |t, args|
    Basic::Models::User.find_by!(email: args[:email]) do |user|
      user.secret = args[:secret]
      user.save
      puts "handling user #{user}"
    end
  end

  desc "Update report with given json payload"
  task :update_report, :shortname, :organization, :comment, :payload do |t, args|
    new_report = Basic::Models::Report.create(
      shortname: args[:shortname],
      organization: args[:organization],
      comment: args[:comment],
      data: YAML::load_file(File.join(__dir__, args[:payload]))
    )
    p "Created report #{new_report.id}"
  end

  desc "Upload reports"
  task :report, :payload do |t, args|
    (puts 'Specify RACK_ENV' and exit) unless ENV['RACK_ENV']
    puts "env is #{ENV['RACK_ENV']}"

    loaded = YAML::load_file(File.join(__dir__, args[:payload]))

    report = Basic::Models::Report.find_or_create_by!(shortname: loaded['shortname'])
    report.organization = loaded['organization']
    report.data = loaded['data']
    report.comment = loaded['comment']
    puts "Save #{report.save}"

    puts "Report #{report.to_json}"
#    puts "Found report #{report}"
  end
end

