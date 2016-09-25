module Basic
  module Auth
    class User < Grape::API
      format :json

      http_basic do |handle, secret|
        authenticates = Basic::Models::User.authenticates_with? handle, secret

        @current_user = Basic::Models::User.find_by(email: handle) if authenticates
        authenticates
      end

      get '/' do
        token = @current_user.produce_token(600)
        expires_at = Time.now+600
        puts "Token #{token.value} for #{@current_user.email} until #{expires_at}"
        { token: token.value, expires_at: expires_at }
      end
    end

    class Admin < Grape::API
      http_basic do |handle, secret|
        { 'yoda' => 'entryirequest' }[handle] == secret 
      end
    end
  end
end
