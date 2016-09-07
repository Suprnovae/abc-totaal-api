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
    end
  end
end
