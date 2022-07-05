class AddCreatedByToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :created_by, :integer
    add_column :items, :updated_by, :integer
  end
end
