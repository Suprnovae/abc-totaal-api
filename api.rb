module Basic
  class API < Grape::API
    get '/version' do
      { name: 'alpha' }
    end

    mount Basic::Overview => '/overview'
  end
end
