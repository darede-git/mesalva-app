class RenameColorToColorHexInNodes < ActiveRecord::Migration[4.2]
  def change
    rename_column :nodes, :color, :color_hex
  end
end
