require 'bcrypt'

module Basic
  module Models
    class Admin
      include Mongoid::Document
      include BCrypt

      include Basic::Ability::Tokenizable

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
    end
  end
end
