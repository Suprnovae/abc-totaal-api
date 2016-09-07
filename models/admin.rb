require 'bcrypt'

module Basic
  module Models
    class Admin
      include Mongoid::Document

      include Basic::Ability::Tokenizable
      include Basic::Ability::Passwordable

      attr_accessor :secret

      field :email, type: String
      field :name, type: String
      field :salt, type: String

      has_many :tokens, as: :tokenizable
      has_and_belongs_to_many :reports

      index({ email: 1 }, { unique: true })

      store_in collection: 'admins'

      before_save :encrypt_password
    end
  end
end
