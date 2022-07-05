class UpdateEssaySubmissionDraft < ActiveRecord::Migration[5.2]
  def change
    query = "UPDATE essay_submissions SET draft = '{}' WHERE draft = '\"{}\"';"
    ActiveRecord::Base.connection.execute(query)
  end
end
