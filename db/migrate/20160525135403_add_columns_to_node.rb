class AddColumnsToNode < ActiveRecord::Migration[4.2]
  def change
    add_column :nodes, :justification, :text
    add_column :nodes, :correct, :boolean
  end
end
