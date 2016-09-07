require 'grape-swagger'

module Basic
  class API < Grape::API
    get '/version' do
      { name: 'alpha' }
    end

    mount Basic::Overview => '/overview'
    mount Basic::Stats => '/stats'
    mount Basic::Hooks::Inbox => '/inbox'
    mount Basic::Hooks::Inbox => '/hooks/report'
    mount Basic::Hooks::UserUpdate => '/hooks/user'

    add_swagger_documentation

    rescue_from :all do |e|
      error!({ error: e.message }, 500)
    end
  end
end
