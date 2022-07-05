class AddActiveToNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :node_modules, :active, :boolean
  end
end
