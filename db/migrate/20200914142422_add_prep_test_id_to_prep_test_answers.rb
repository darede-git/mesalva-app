# frozen_string_literal: true

class AddPrepTestIdToPrepTestAnswers < ActiveRecord::Migration[5.2]
  def up
    add_column :prep_test_scores, :prep_test_id, :bigint, foreign_key: true

    PrepTest.all.each do |prep_test|
      execute <<-SQL
        UPDATE prep_test_scores
        SET prep_test_id = #{prep_test.id}
        WHERE prep_test_scores.permalink_slug ilike '%#{prep_test.permalink_slug}%'
      SQL
    end
  end

  def down
    remove_column :prep_test_scores, :prep_test_id
  end
end
