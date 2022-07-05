class DropPermalinkNodeModule < ActiveRecord::Migration[4.2]
  def change
    drop_table :permalink_node_modules
  end
end
