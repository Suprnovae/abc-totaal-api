require 'grape-swagger'

module Basic
  class API < Grape::API
    get '/version' do
      { name: 'alpha' }
    end

    # TODO: phase out /overview for /reports
    mount Basic::Overview => '/overview'
    mount Basic::Reports => '/reports'
    mount Basic::Stats => '/stats'
    # TODO: phase out /inbox for /hooks/report
    mount Basic::Hooks::Inbox => '/inbox'
    # TODO: rename Inbox to Report
    mount Basic::Hooks::Inbox => '/hooks/report'
    mount Basic::Hooks::UserUpdate => '/hooks/user'

    mount Basic::Auth::User => '/auth/user'
    #mount Basic::Auth::Admin => '/auth/admin'

    add_swagger_documentation

    rescue_from :all do |e|
      error!({ error: e.message }, 500)
    end

    Grape::Middleware::Auth::Strategies.add(:bearer, Basic::Bearer, ->(o) { o[:realm] })

    route :any, '*path' do
      error!({ error: 'Nonexistent URI' }, 404)
    end
  end
end
