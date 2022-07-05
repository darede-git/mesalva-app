class AddSlugAndDescriptionToRoles < ActiveRecord::Migration[5.2]
  def up
    add_column :roles, :slug, :string, index: true
    add_column :roles, :description, :text

    execute <<-SQL
      UPDATE roles SET slug = name;
    SQL

    add_index :roles, :slug, unique: true
    add_column :permissions, :description, :text
    remove_column :permissions, :expires_at_suggestion
  end
  def down
    remove_column :roles, :slug
    remove_column :roles, :description
    remove_index :roles, :slug
    remove_column :permissions, :description
    add_column :permissions, :expires_at_suggestion, :datetime
  end
end
