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
       p "Attachments #{attachments}"

       if attachments > 0
         (1..attachments).each do |attachment_id|
           file = params["attachment-#{attachment_id}"]
           filename = file[:filename]
           basename = File.basename(filename, File.extname(filename))
           label = filename..gsub!(/( )+/, '_').downcase
           doc = Basic::Models::Report.find_or_initialize_by shortname: label
           if attachments == 1
             doc.organization = subject
             doc.comment = comment
           end
           p "======="
           p "Filename #{filename}"
           p "Label #{label}"
           p "Size #{file[:tempfile].size}"
           p "Path #{file[:tempfile].path}"
           csv = CSV.new(file[:tempfile], headers: true, converters: :all)
           data = csv.to_a.map do |row| 
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
           p "Data for #{label} is #{data}"
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
