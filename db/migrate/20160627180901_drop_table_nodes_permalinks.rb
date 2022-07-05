class DropTableNodesPermalinks < ActiveRecord::Migration[4.2]
  def change
    drop_table :nodes_permalinks
  end
end
