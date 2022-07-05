class AddBirthDateToAdmin < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :birth_date, :date
    add_column :admins, :description, :text
  end
end
