class AddAncestryToNodes < ActiveRecord::Migration[4.2]
  def change
    add_column :nodes, :ancestry, :string
  end
end
