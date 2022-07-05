class ChangeColorNameColumnToColor < ActiveRecord::Migration[4.2]
  def change
    rename_column :nodes, :color_name, :color
    rename_column :node_modules, :color_name, :color
  end
end
