require 'csv'
require 'json'

module Basic
  class Inbox < Grape::API
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

          log.info "Attachment #{attachment_id} for #{label}: #{filename} #{path} #{size}bytes"

          csv = CSV.new(file[:tempfile],
                        col_sep: ';',
                        headers: true,
                        converters: :all)
          data = csv.to_a.map do |row| 
            log.info "Row: #{row.to_json}"
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
            res[:error] = e.message
          end
        end
      else
        status 406 # missing information
        res[:error] = ['Attachment required']
      end # if attachments exist
      log.info "Created report: #{res.to_json}"
      log.error "Failed because: #{res[:error]}" if res[:error]
      res
    end
  end
end
