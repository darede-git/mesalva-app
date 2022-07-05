class RemoveNodeModuleFromSubject < ActiveRecord::Migration[4.2]
  def change
    remove_column :subjects, :node_module_id, :integer
  end
end
