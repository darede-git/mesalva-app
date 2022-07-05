class RemoveWeightFromNode < ActiveRecord::Migration[4.2]
  def change
    remove_column :nodes, :weight, :integer
  end
end
