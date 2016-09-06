require 'bcrypt'
require 'openssl'

module Basic
  module Models
    class Admin
      include Mongoid::Document
      include BCrypt

      attr_accessor :secret

      field :email, type: String
      field :name, type: String
      field :salt, type: String

      has_many :tokens, as: :tokenizable
      has_and_belongs_to_many :reports

      index({ email: 1 }, { unique: true })

      store_in collection: 'admins'

      before_save :encrypt_password

      def has_password?(secret)
        return true if self.password == secret
        false
      end

      def self.authenticates_with?(handle, secret)
        user = self.where(email: handle).first
        user && user.has_password?(secret)
      end

      def password
        Password.new(self.salt)
      end

      def encrypt_password
        self.salt = Password.create(@secret)
      end

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
