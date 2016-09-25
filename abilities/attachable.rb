class IncompleteAttachmentException < RuntimeError; end
module Basic
  module Ability
    module Attachable
      require 'csv'

      def read_csv(file)
        CSV.new(file, col_sep: ';', headers: true, converters: :all)
      end

      def extract_value(val, source)
        fail(IncompleteAttachmentException, "#{val} missing from #{source}") if source[val].nil?
        fail(IncompleteAttachmentException, "#{val} empty in #{source}") if source[val].empty?
        source[val]
      end

      def extract_report_from(file)
        read_csv(file).to_a.map do |row|
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
      end

      def for_every_csv_attachment(n, params)
        if n > 0
          (1..n).each do |attachment_n|
            file = params["attachment-#{attachment_n}"]
            filename = file[:filename]
            next unless File.extname(filename).downcase == ".csv"
            yield file
          end
        end
      end

      def extract_users_from(file)
        read_csv(file).to_a.map do |row|
          {
            handle: extract_value('Email', row),
            secret: extract_value('Wachtwoord', row),
            report: extract_value('Bedrijf', row),
          }
        end
      end
    end
  end
end
