module Basic
  class Overview < Grape::API
    format :json

    http_basic do |handle, secret|
      @current_user = Basic::Models::User.where(email: handle).first
      @current_user && @current_user.has_password?(secret)
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
