# frozen_string_literal: true

class CreateMediumRating < ActiveRecord::Migration[5.2]
  def change
    create_table :medium_ratings do |t|
      t.references :medium, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :value
    end
  end
end
