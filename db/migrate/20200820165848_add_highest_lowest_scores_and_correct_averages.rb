# frozen_string_literal: true

class AddHighestLowestScoresAndCorrectAverages < ActiveRecord::Migration[5.2]
  def change
    add_column :prep_tests, :cnat_average_correct, :integer
    add_column :prep_tests, :chum_average_correct, :integer
    add_column :prep_tests, :ling_average_correct, :integer
    add_column :prep_tests, :mat_average_correct, :integer

    rename_column :prep_tests, :cnat_average, :cnat_average_score
    rename_column :prep_tests, :chum_average, :chum_average_score
    rename_column :prep_tests, :ling_average, :ling_average_score
    rename_column :prep_tests, :mat_average, :mat_average_score
  end
end
