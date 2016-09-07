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

      p "Recipient: #{recipient}"
      p "Sender: #{sender}"
      p "From: #{from}"
      p "Subject: #{subject}"
      p "Comment:#{comment}"
      p "Attachments: #{attachments}"

      res = {}

      if attachments > 0
        (1..attachments).each do |attachment_id|
          file = params["attachment-#{attachment_id}"]
          filename = file[:filename]
          basename = File.basename(filename, File.extname(filename))
          label = basename.gsub!(/( )+/, '_').downcase
          doc = Basic::Models::Report.find_or_initialize_by shortname: label
          doc.updated_at = Time.now

          if attachments == 1
            doc.organization = subject
            doc.comment = comment
          end

          size = file[:tempfile].size
          path = file[:tempfile].path

          p " - label=#{label} size=#{size} path=#{path} filename=#{filename}"

          csv = CSV.new(file[:tempfile],
                        col_sep: ';',
                        headers: true,
                        converters: :all)
          data = csv.to_a.map do |row| 
            p "Row: #{row.to_hash}"
            {
              description: row["KSF"],
              predicted: row["Prognose"],
              actual: row["Realisatie"],
              tablets: [
                { text: row["Tot en met"]},
                { text: row["Jaar"]}
              ],
              unit: (ENV['DEFAULT_CURRENCY'] || "EUR"),
            }
          end

          p "Data for #{label} is #{data}"
          doc.data = data

          res = {
            shortname: doc.shortname,
            organization: doc.organization,
            comment: doc.comment,
            created_at: doc.created_at,
            updated_at: doc.updated_at,
            data: doc.data
          }

          begin
            doc.save!
            status :created
            res[:id] = doc.id
          rescue e
            status :conflict
            res[:error] = e
          end
        end
      else
        status 406 # missing information
        res[:error] = ['Attachment required']
      end # if attachments exist
      p "result is #{res}"
      res
    end
  end
end
