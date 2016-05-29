require 'spec_helper'

describe Basic::API do
  include Rack::Test::Methods

  def app
    Basic::API
  end
end
