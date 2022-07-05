class DropColumnPositionOnPermalinkNodeModule < ActiveRecord::Migration[4.2]
  def change
    remove_column :permalink_node_modules, :position, :integer
  end
end
