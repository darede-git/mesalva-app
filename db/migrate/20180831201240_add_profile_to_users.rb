class AddProfileToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :profile, :string
  end
end
