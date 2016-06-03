module Basic
  class Inbox < Grape::API
     post '/' do
       # https://documentation.mailgun.com/user_manual.html#routes
       recipient = params[:recipient]
       sender = params[:sender]
       from = params[:from]
       subject = params[:subject]
       attachments = JSON.parse(params[:attachment])
       p "Recipient is #{recipient}"
       p "Sender is #{sender}"
       p "From #{from}"
       p "Subject is #{subject}"
       attachments.each do |attachment|
         p "Attachment is #{attachment}"
       end
       status :created
       # status :conflict
    end
  end
end
