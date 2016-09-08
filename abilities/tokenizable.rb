require 'openssl'

module Basic
  module Ability
    module Tokenizable
      def produce_token(ttl=(ENV['DEFAULT_SESSION_DURATION'] || 600))
        digest = OpenSSL::Digest.new('sha256')
        key = password
        data = SecureRandom.uuid

        token = OpenSSL::HMAC.hexdigest(digest, key, data)

        puts "#{email}: HMAC(key=#{key} data=#{data} ttl=#{ttl}) => #{token}"

        return self.tokens.create({value: token, expires_on: Time.now+ttl})
      end

      def has_token?(value)
        begin
          token = Basic::Models::Token.find_by(value: value)
          return token.tokenizable == self
        rescue Mongoid::Errors::DocumentNotFound
          return false
        end
      end
    end
  end

  class Bearer < Rack::Auth::AbstractHandler
    def call(env)
      auth = Bearer::Request.new(env)

      return unauthorized unless auth.provided?

      return bad_request unless auth.bearer?

      if valid?(auth)
        env['REMOTE_USER'] = auth.user.email
        @current_user = auth.user
        return @app.call(env)
      end

      unauthorized
    end


    private

    def challenge
      'Bearer realm="%s"' % realm
    end

    def valid?(auth)
      @authenticator.call(realm, *auth.bearer_token)
    end

    class Request < Rack::Auth::AbstractRequest
      def bearer?
        "bearer" == scheme
      end

      def bearer_token
        @bearer_token ||= params.to_s #.unpack("m*").first.split(/:/, 2)
      end

      def user
         begin
           token = Basic::Models::Token.find_by(value: bearer_token)
           return token.tokenizable
         rescue Mongoid::Errors::DocumentNotFound
           return nil
         end
      end
    end
  end
end
