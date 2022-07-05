class AddNodeModuleToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_reference :permalinks, :node_module, index: true, foreign_key: true
  end
end
