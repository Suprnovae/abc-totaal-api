module Basic
  module Ability
    module Attachable
      require 'csv'

      class IncompleteAttachmentException < RuntimeError
      end

      def read_csv(filename)
        CSV.new(File.open(filename),
                col_sep: ';',
                headers: true,
                converters: :all)
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
