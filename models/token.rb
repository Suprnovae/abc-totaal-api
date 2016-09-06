require 'bcrypt'
require 'openssl'

module Basic
  module Models
    class Token
      include Mongoid::Document

      belongs_to :tokenizable, polymorphic: true

      index({ expires_on: 1 }, { expire_after_seconds: 0 })

      field :value, type: String
      field :expires_on, type: Date

      store_in collection: 'tokens'
    end
  end
end
