module Basic
  module Models
    class Report
      include Mongoid::Document
      
      field :shortname, type: String
      field :organization, type: String
      field :comment, type: String
      field :created_at, type: DateTime, default: Time.now
      field :updated_at, type: DateTime, default: Time.now
      field :data, type: Array

      index({ shortname: 1 }, { unique: true })

      store_in collection: 'reports'

      has_and_belongs_to_many :admins
    end
  end
end
