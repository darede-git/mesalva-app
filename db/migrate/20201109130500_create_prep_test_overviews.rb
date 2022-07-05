# frozen_string_literal: true

class CreatePrepTestOverviews < ActiveRecord::Migration[5.2]
  def change
    create_table :prep_test_overviews do |t|
      t.string :user_uid, index: true, nullable: false
      t.string :token
      t.float :score
      t.string :permalink_slug
      t.integer :corrects
      t.jsonb :answers, nullable: false, default: []

      t.timestamps
    end
  end
end
