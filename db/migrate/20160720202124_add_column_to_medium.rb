class AddColumnToMedium < ActiveRecord::Migration[4.2]
  def change
    add_column :media, :code, :string 
    add_column :media, :correction, :text
    add_column :media, :matter, :string 
    add_column :media, :subject, :string 
    add_column :media, :difficulty, :string 
    add_column :media, :concourse, :string 
    add_column :media, :created_by, :integer 
    add_column :media, :updated_by, :integer 
    add_column :media, :active, :boolean 
  end
end
