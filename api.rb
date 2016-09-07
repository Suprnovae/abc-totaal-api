require 'grape-swagger'

module Basic
  class API < Grape::API
    get '/version' do
      { name: 'alpha' }
    end

    mount Basic::Overview => '/overview'
    mount Basic::Stats => '/stats'
    mount Basic::Inbox => '/inbox'

    add_swagger_documentation

    rescue_from :all do |e|
      error!({ error: e.message }, 500)
    end
  end
end
