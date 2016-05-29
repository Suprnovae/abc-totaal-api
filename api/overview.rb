module Basic
  class Overview < Grape::API
    format :json

    http_basic do |email, secret|
      Basic::Models::User.authenticates_with?(email, secret)
      @current_user = Basic::Models::User.where(email: email).first
    end

    get '/' do
      report = @current_user.report
      {
        shortname: report.shortname,
        organization: report.organization,
        comment: report.comment,
        updated_at: report.updated_at,
        data: report.data
      }
    end
  end
end
