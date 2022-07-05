# frozen_string_literal: true

class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.string :schools, array: true
      t.string :subjects, array: true
      t.integer :students
      t.references :package, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
