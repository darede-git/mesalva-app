# frozen_string_literal: true

class AddReferencesToPrepTestAndPrepTestScores < ActiveRecord::Migration[5.2]
  def change
    add_index :prep_test_scores, :permalink_slug
    add_index :prep_tests, :permalink_slug
  end
end
