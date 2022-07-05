class DropTableMediaNodes < ActiveRecord::Migration[4.2]
  def change
    drop_table :media_nodes
  end
end
