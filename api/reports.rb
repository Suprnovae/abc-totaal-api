module Basic
  class Reports < Grape::API
    format :json

		auth :bearer, { realm: 'User' } do |realm, secret|
      p "bearer creds #{[realm, secret.to_s]}"
      begin
        token = Basic::Models::Token.find_by(value: secret)
        !token.expired?
      rescue Mongoid::Errors::DocumentNotFound
        false
      end
    end

    get '/' do
      @current_user = Basic::Models::User.first
      #p "current_user.reports = #{@current_user.reports}"
#      @current_user.reports.map do |report|
#        {
#          shortname: report.shortname,
#          organization: report.organization,
#          comment: report.comment,
#          updated_at: report.updated_at,
#          data: report.data
#        }
#      end
      []
    end
  end
end
