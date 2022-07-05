class RemoveFieldsFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :nickname, :string
    remove_column :users, :courses, :string
    remove_column :users, :biography, :text
    remove_column :users, :slug, :string
  end
end
