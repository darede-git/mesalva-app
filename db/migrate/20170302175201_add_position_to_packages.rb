class AddPositionToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :position, :integer, default: 0
  end
end
