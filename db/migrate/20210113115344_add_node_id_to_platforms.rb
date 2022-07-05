class AddNodeIdToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :node_id, :bigint, nullable: false
    add_foreign_key :platforms, :nodes
  end
end
