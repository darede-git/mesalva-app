# frozen_string_literal: true

class CreatePrepTests < ActiveRecord::Migration[5.2]
  def change
    create_table :prep_tests do |t|
      t.float :cnat_min_score
      t.float :cnat_average
      t.float :cnat_max_score

      t.float :chum_min_score
      t.float :chum_average
      t.float :chum_max_score

      t.float :ling_min_score
      t.float :ling_average
      t.float :ling_max_score

      t.float :mat_min_score
      t.float :mat_average
      t.float :mat_max_score

      t.string :permalink_slug, uniqueness: true
      t.date :average_measured_at

      t.timestamps
    end
  end
end
