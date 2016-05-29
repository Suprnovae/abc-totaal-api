module Basic
  module Models
    class User
      include Mongoid::Document

      field :email, type: String
      field :name, type: String
      #field :salt, type: String
      field :report_id, type: BSON::ObjectId

      index({ email: 1 }, { unique: true })

      store_in collection: 'users'

      def report
        p "report_id is #{report_id}"
        Basic::Models::Report.find(report_id)
      end

      def report=(existing_report)
        p "report id is #{existing_report.id}"
        #update_attributes(report_id: existing_report.id)
      end
    end
  end
end
