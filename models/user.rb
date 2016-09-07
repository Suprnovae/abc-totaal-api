require 'bcrypt'

module Basic
  module Models
    class User
      include Mongoid::Document

      include Basic::Ability::Tokenizable
      include Basic::Ability::Passwordable

      attr_accessor :secret

      field :email, type: String
      field :name, type: String
      field :salt, type: String
      field :report_id, type: BSON::ObjectId

      validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

      has_many :tokens, as: :tokenizable

      index({ email: 1 }, { unique: true })

      store_in collection: 'users'

      def report
        Basic::Models::Report.find(report_id)
      end

      def report=(existing_report)
        self.report_id = existing_report.id
      end

      before_save :encrypt_password
    end
  end
end
