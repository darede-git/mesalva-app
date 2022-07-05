class RemoveObjectiveFromNodes < ActiveRecord::Migration[4.2]
  def change
    remove_column :nodes, :objective
  end
end
