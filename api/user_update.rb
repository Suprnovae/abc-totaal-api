require 'csv'
require 'json'

module Basic
  module Hooks
    class UserUpdate < Grape::API
      helpers do
        def log
          API.logger.new(STDOUT)
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
  
        user = Basic::Models::User.find_or_initialize_by email: subject
        is_new = user.new_record?

        res[:email] = subject 

        filename = subject.strip
        basename = File.basename(filename, File.extname(filename))
        label = basename.gsub!(/( )+/, '_').downcase

        report = subject.strip

        status 406
        if attachments == 1
          file = params["attachment-#{1}"]
          size = file[:tempfile].size
          path = file[:tempfile].path

          password = CSV.new(file[:filename], headers: false)[0][0]
          raise "Password required" if (!password || password == nil)
          
          begin
            password = File.read(path)
            user.password = password
            user.save!
            status :created
            res[:user_id] = user.id.to_s
          rescue e
            status :conflict
            res[:error] = e.message
          end
        else
          log.warn "#{attachments} attachments found instead of one"
        end
        action = (("created" if (is_new)) or "updated")
        action = "unsaved" unless user.persisted?
        log.info "User #{subject} #{action}"
        log.error "Failed because: #{res[:error]}" if res[:error]
        res
      end
    end
  end
end
