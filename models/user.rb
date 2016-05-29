require 'bcrypt'

module Basic
  module Models
    class User
      include Mongoid::Document
      include BCrypt

      attr_accessor :secret
      #attr_protected :salt

      field :email, type: String
      field :name, type: String
      field :salt, type: String
      field :report_id, type: BSON::ObjectId

      index({ email: 1 }, { unique: true })

      store_in collection: 'users'

      def report
        Basic::Models::Report.find(report_id)
      end

      def report=(existing_report)
        self.report_id = existing_report.id
      end

      before_save :encrypt_password

      def self.authenticates_with?(handle, secret)
        user = where(email: handle).first
        return false unless user
        Password.new(user.salt) == secret
      end

      def encrypt_password
        self.salt = Password.create(@secret)
      end
    end
  end
end
