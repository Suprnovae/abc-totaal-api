require 'grape'

Dir[File.dirname(__FILE__) + '/../api/*.rb'].each {|file| require file }

require File.dirname(__FILE__) + '/../api.rb'
