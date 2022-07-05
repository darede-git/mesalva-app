class AddListedToContentTables < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :listed, :boolean, default: true
    add_column :node_modules, :listed, :boolean, default: true
    add_column :items, :listed, :boolean, default: true
    add_column :media, :listed, :boolean, default: true
  end
end
