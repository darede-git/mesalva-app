class CreateJoinTableNodeModuleMedium < ActiveRecord::Migration[4.2]
  def change
    create_join_table :node_modules, :media do |t|
      t.index [:node_module_id, :medium_id]
      t.index [:medium_id, :node_module_id]
    end
  end
end
