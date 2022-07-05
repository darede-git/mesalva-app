# frozen_string_literal: true

class CreatePrepTestDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :prep_test_details do |t|
      t.string :token, index: true, nullable: false
      t.jsonb :options, nullable: false, default: {}
      t.integer :weight
      t.string :type

      t.timestamps
    end
  end
end
