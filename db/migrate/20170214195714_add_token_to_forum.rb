class AddTokenToForum < ActiveRecord::Migration[4.2]
  def change
    add_column :forums, :token, :string
    add_index :forums, :token, unique: true

    add_column :subjects, :token, :string
    add_index :subjects, :token, unique: true

    add_column :topics, :token, :string
    add_index :topics, :token, unique: true

    add_column :comments, :token, :string
    add_index :comments, :token, unique: true

    add_column :promotes, :token, :string
    add_index :promotes, :token, unique: true

    add_column :votes, :token, :string
    add_index :votes, :token, unique: true
  end
end
