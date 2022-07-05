# frozen_string_literal: true

class AddLastCheckedForStudentsInInstructors < ActiveRecord::Migration[5.2]
  def change
    add_column :instructors, :last_checked_for_students, :timestamp
  end
end
