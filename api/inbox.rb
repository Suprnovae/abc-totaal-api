module Basic
  class Inbox < Grape::API
     post '/' do
       # https://documentation.mailgun.com/user_manual.html#routes
       p "========================================"
       recipient = params[:recipient]
       sender = params[:sender]
       from = params[:from]
       subject = params[:subject]
       p "Recipient is #{recipient}"
       p "Sender is #{sender}"
       p "From #{from}"
       p "Subject is #{subject}"
       p "params #{params}"
       p "request #{request}"
       p request
       p "There are #{params[:'attachment-count'] || 0} attachments"
       # how to get an attachment from Mailgun?
       if params[:'attachment-count']
         (1..params[:'attachment-count']).each do |attachment_id|
           file = params["attachment-#{attachment_id}"]
           p "FILE #{file}"
           p "file #{file[:tempfile]}"
           p "head#{file[:head]}"
         end
       end
#       if params[:attachments]
#         attachments = JSON.parse(params[:attachment])
#         attachments.each do |attachment, index|
#           p " - Attachment is #{attachment}"
#           p "   Contains #{params[:"attachment-#{index}"]}"
#         end
#       end
       status :created
       # status :conflict
    end
  end
end
