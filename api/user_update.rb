require 'csv'
require 'json'

module Basic
  module Hooks
    class UserUpdate < Grape::API
      format :json

      helpers do
        include Basic::Ability::Attachable
        def log
          API.logger
        end
      end

      post '/' do
        # https://documentation.mailgun.com/user_manual.html#routes
        recipient = params[:recipient]
        sender = params[:sender]
        from = params[:from]
        subject = params[:subject]
        comment = params[:'body-plain']
        attachments = (params[:'attachment-count'].to_i || 0)

        log.info "Recipient: #{recipient}"
        log.info "Sender: #{sender}"
        log.info "From: #{from}"
        log.info "Subject: #{subject}"
        log.info "Comment:#{comment}"
        log.info "Attachment counts: #{attachments}"

        is_new = nil

        status 406
        res = { error: [], users: [] }

        begin
          users = []
          for_every_csv_attachment(attachments, params) do |i, file|
            log.info "Extracting users from #{file}"
            extract_users_from(file[:tempfile]).map { |u|
              user = Basic::Models::User.find_or_initialize_by email: u[:handle]
              is_new = user.new_record?
              user.secret = u[:secret]
              user.report = Basic::Models::Report.find_by(
                shortname: sanitize(u[:report])
              )
              user.save!
              log.info "Populated document for #{u}"
              status :ok
              res[:users] << { id: user.id.to_s, email: u[:handle] }
              users << user.as_document
            }
            log.info "#{users.count} users pending to be updated to #{users}"
          end
        rescue => e
          status :conflict
          res[:error] << e.message
          log.error e
        end
        res[:error] << 'Attachment required' if attachments == 0
        log.error "Failed because: #{res[:error]}" unless res[:error].empty?
        res
      end
    end
  end
end
