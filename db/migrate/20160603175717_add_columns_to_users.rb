class AddColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :birth_date, :date
    add_column :users, :area_code, :string
    add_column :users, :phone_number, :string
    add_column :users, :gender, :string
    add_column :users, :user_type, :integer
    add_column :users, :studies, :string
    add_column :users, :courses, :string
    add_column :users, :dreams, :string
    add_column :users, :biography, :text
  end
end
