require 'csv'

module Basic
  class Inbox < Grape::API
     post '/' do
       # https://documentation.mailgun.com/user_manual.html#routes
       p "========================================"
       recipient = params[:recipient]
       sender = params[:sender]
       from = params[:from]
       subject = params[:subject]
       comment = params[:'body-plain']
       attachments = (params[:'attachment-count'].to_i || 0)
       p "Recipient is #{recipient}"
       p "Sender is #{sender}"
       p "From #{from}"
       p "Subject is #{subject}"
       p "Comment is #{comment}"
       #p "params #{params}"
       #p "request #{request}"
       #p request
       p "Attachments #{attachments}"
       # how to get an attachment from Mailgun?
       if attachments > 0
         (1..attachments).each do |attachment_id|
           file = params["attachment-#{attachment_id}"]
           label = file[:filename].strip.downcase.splice!('.csv')
           doc = Basic::Models::Report.find_or_initialize_by shortname: label
           if false
             doc.organization = subject
             doc.comment = comment
           end
           p "label is #{label}"
           #p "FILE #{file}"
           #p "name #{file[:filename].downcase.splice!('.csv')}"
           p "file #{file[:tempfile]}"
           p "size #{file[:tempfile].size}"
           p "path #{file[:tempfile].path}"
           data = CSV.new(file[:tempfile], headers: true, converters: :all)
           p "data is #{data}"
           data.map do |row| 
             {
               description: row["KSF"],
               predicted: row["Prognose"],
               actual: row["Realisatie"],
               tablets: [
                 { text: row["Tot en met"]},
                 { text: row["Jaar"]}
               ]
             }
           end
           p "data for #{label} is #{data}"
           doc.data = data
           if doc.save
             status :created
           else
             status :conflict
           end
         end
       end # if attachments exist
       status 406 # missing information
    end
  end
end
