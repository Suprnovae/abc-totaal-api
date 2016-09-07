require 'rack/test'
require 'mongoid-rspec'
if ENV['RACK_ENV'] == 'test'
  require 'pry'
end

require File.expand_path('../../config/env', __FILE__)

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
end

[
  Basic::Models::Report,
  Basic::Models::User,
  Basic::Models::Admin,
  Basic::Models::Token,
].each do |model|
  model.destroy_all
  model.remove_indexes
  model.create_indexes
end
