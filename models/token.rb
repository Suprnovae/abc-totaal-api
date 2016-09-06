require 'bcrypt'
require 'openssl'

module Basic
  module Models
    class Token
      include Mongoid::Document

      belongs_to :tokenizable, polymorphic: true

      field :value, type: String
      field :expires_on, type: Time, default: Time.now+600

      index({ value: 1 }, { unique: true })
      index({ expires_on: 1 }, { expire_after_seconds: 0 })

      store_in collection: 'tokens'

      validates_presence_of :value
    end
  end
end
