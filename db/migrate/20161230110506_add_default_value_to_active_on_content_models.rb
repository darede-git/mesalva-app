class AddDefaultValueToActiveOnContentModels < ActiveRecord::Migration[4.2]
  def change
    change_column :nodes, :active, :boolean, default: true
    change_column :node_modules, :active, :boolean, default: true
    change_column :items, :active, :boolean, default: true
    change_column :media, :active, :boolean, default: true
  end
end
