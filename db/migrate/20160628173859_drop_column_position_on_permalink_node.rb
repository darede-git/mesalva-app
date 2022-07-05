class DropColumnPositionOnPermalinkNode < ActiveRecord::Migration[4.2]
  def change
    remove_column :permalink_nodes, :position, :integer
  end
end
