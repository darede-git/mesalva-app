class ChangeNodeFields < ActiveRecord::Migration[4.2]
  def change
    remove_column :nodes, :thumb
    remove_column :nodes, :code
    add_column :nodes, :info, :text
    add_column :nodes, :old_id, :integer
    add_column :nodes, :node_video, :string
    add_column :nodes, :old_package_id, :integer
    add_column :nodes, :og_description, :text
  end
end
