class CreateJoinTableNodeModuleItem < ActiveRecord::Migration[4.2]
  def change
    create_join_table :node_modules, :items do |t|
      t.index [:node_module_id, :item_id]
      t.index [:item_id, :node_module_id]
    end
  end
end
