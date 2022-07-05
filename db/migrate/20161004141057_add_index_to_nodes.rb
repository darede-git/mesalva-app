class AddIndexToNodes < ActiveRecord::Migration[4.2]
  def change
    add_index :nodes, :ancestry
  end
end
