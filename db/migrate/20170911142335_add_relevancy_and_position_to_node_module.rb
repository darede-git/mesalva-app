class AddRelevancyAndPositionToNodeModule < ActiveRecord::Migration[4.2]
  def change
    add_column :node_modules, :relevancy, :integer, default: 1
    add_column :node_modules, :position, :integer
  end
end
