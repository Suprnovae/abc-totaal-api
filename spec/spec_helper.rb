require 'rack/test'
require 'mongoid-rspec'

require File.expand_path('../../config/env', __FILE__)

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
end

[Basic::Models::Report, Basic::Models::User].each do |model|
  model.remove_indexes
  model.create_indexes
end
