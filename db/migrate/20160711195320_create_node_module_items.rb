class CreateNodeModuleItems < ActiveRecord::Migration[4.2]
  def change
    create_table :node_module_items do |t|
      t.belongs_to :node_module, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
