module Basic
  module Ability
    module Attachable
      require 'csv'

      def read_csv(filename)
        CSV.new(File.open(filename),
                col_sep: ';',
                headers: true,
                converters: :all)
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
      end
    end
  end
end
