require 'bcrypt'

module Basic
  module Ability
    module Passwordable
      include BCrypt

      def has_password?(secret)
        return true if self.password == secret
        false
      end

      def password
        Password.new(self.salt)
      end

      def encrypt_password
        self.salt = Password.create(@secret)
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def authenticates_with?(handle, secret)
          user = self.where(email: handle).first
          user && user.has_password?(secret)
        end
      end
    end
  end
end
