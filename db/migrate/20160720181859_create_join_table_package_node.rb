class CreateJoinTablePackageNode < ActiveRecord::Migration[4.2]
  def change
    create_join_table :packages, :nodes do |t|
      t.index [:package_id, :node_id]
      t.index [:node_id, :package_id]
    end
  end
end
