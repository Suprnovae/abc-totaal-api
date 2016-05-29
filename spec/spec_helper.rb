require 'rack/test'
require 'mongoid-rspec'

require File.expand_path('../../config/env', __FILE__)

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :model
end
