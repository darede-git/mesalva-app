class AddTitleToForum < ActiveRecord::Migration[4.2]
  def change
      add_column :forums, :title, :string
      add_column :forums, :slug, :string
  end
end
