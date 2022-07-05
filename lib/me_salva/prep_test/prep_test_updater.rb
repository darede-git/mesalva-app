# frozen_string_literal: true

module MeSalva
  module PrepTest
    class PrepTestUpdater
      def update_from_csv(filename)
        @file = CSV.read(open("https://mesalva-uploads.s3.amazonaws.com/uploads/csv/scripts/#{filename}.csv"))
        @head = @file.slice!(0)

        @file.map do |row|
          medium = Medium.find_by_name(row[0])
          next if medium.nil?

          question_number = row[2]
          answer_letter = row[3]
          subject = row[4]
          competence_raw = row[6]
          ability_raw = row[7]
          label = row[8]
          permalink_raw = row[9]
          medium.update(options: {
            label: label,
            ability: ability_raw.gsub(/^(H\d).*/, '\1'),
            permalink: permalink_raw.gsub(/https:\/\/www\.mesalva\.com\//, ''),
            competence: competence_raw.gsub(/^(C\d).*/, '\1'),
            abilityDescription: ability_raw.gsub(/^H\d - /, ''),
            competenceDescription: competence_raw.gsub(/^C\d - /, ''),
            originalTestQuestionNumber: question_number,
            answerLetter: answer_letter,
            subject: subject,
          })
        end
      end
    end
  end
end
