require 'csv'
require 'json'

module Basic
  module Hooks
    class Inbox < Grape::API
      helpers do
        include Basic::Ability::Attachable
      end

      format :json

      helpers do
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

        res = {}
        is_new = nil

        status = 406
        begin
          for_every_csv_attachment(attachments, params) do |i, file|
            filename = file[:filename]
            basename = File.basename(filename, File.extname(filename))
            label = sanitize basename
            doc = Basic::Models::Report.find_or_initialize_by shortname: label

            is_new = doc.new_record?
            doc.updated_at = Time.now
  
            if attachments == 1
              doc.organization = subject
              doc.comment = comment
            end

            size = file["tempfile"].size
            path = file["tempfile"].path
  
            log.info "Attachment #{i} for #{label}: #{filename} #{path} #{size}bytes"
            doc.data = extract_report_from(file["tempfile"])

            res = {
              shortname: doc.shortname,
              organization: doc.organization,
              comment: doc.comment,
              created_at: doc.created_at,
              updated_at: doc.updated_at,
              data: doc.data
            }

            doc.save!
            action = ((:created if is_new) or :ok)
            status action
            res[:id] = doc.id.to_s
          end # for every csv
        rescue => e
          status(:conflict)
          res[:error] = e.message
        end
        res[:error] = ['Attachment required'] if attachments == 0
        log.info "Created report: #{res.to_json}"
        log.error "Failed because: #{res[:error]}" if res[:error]
        res
      end
    end
  end
end
