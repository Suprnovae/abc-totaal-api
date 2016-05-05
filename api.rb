module Basic
  class API < Grape::API
    get '/version' do
      { name: 'alpha' }
    end
  end
end
