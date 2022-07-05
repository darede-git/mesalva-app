class AddColumnToNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :node_modules, :code, :string
  end
end
