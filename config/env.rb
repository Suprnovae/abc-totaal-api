require 'rubygems'
require 'bundler/setup'

require 'grape'
require 'mongoid'

def require_files_that_match(pattern)
  Dir[File.dirname(__FILE__) + pattern].each {|file| require file }
end
Mongoid.load! File.dirname(__FILE__) + '/mongoid.yml'
require_files_that_match('/../api/*.rb')
require_files_that_match('/../models/*.rb')

require File.dirname(__FILE__) + '/../api.rb'
