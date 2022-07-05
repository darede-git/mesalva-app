class AddPositionToPermalinkNodes < ActiveRecord::Migration[4.2]
  def change
    add_column :permalink_nodes, :position, :integer
  end
end
