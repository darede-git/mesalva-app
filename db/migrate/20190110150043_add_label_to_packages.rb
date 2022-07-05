class AddLabelToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :label, :text, array: true, default: []
  end
end
