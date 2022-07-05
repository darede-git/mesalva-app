class ChangesPermalinkNodesConstraintToCascade < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :permalink_nodes, :permalinks
    add_foreign_key :permalink_nodes, :permalinks, on_delete: :cascade
  end
end
