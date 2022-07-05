class AddBirthDateToTeacher < ActiveRecord::Migration[4.2]
  def change
    add_column :teachers, :birth_date, :date
  end
end
