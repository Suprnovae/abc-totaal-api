require 'rubygems'
require 'bundler/setup'

require 'grape'
require 'mongoid'

Mongoid.load! File.dirname(__FILE__) + '/mongoid.yml'
Dir[File.dirname(__FILE__) + '/../api/*.rb'].each {|file| require file }

require File.dirname(__FILE__) + '/../api.rb'
