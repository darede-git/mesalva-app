# frozen_string_literal: true

class AddLingEspLingIngToPrepTest < ActiveRecord::Migration[5.2]
  def change
    add_column :prep_tests, :ling_esp_min_score, :float
    add_column :prep_tests, :ling_esp_average_score, :float
    add_column :prep_tests, :ling_esp_max_score, :float
    add_column :prep_tests, :ling_esp_average_correct, :int

    rename_column :prep_tests, :ling_min_score, :ling_ing_min_score
    rename_column :prep_tests, :ling_average_score, :ling_ing_average_score
    rename_column :prep_tests, :ling_max_score, :ling_ing_max_score
    rename_column :prep_tests, :ling_average_correct, :ling_ing_average_correct
  end
end
