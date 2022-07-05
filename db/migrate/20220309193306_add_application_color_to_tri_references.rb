class AddApplicationColorToTriReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :tri_references, :application, :integer, default: 1
    add_column :tri_references, :color, :string, default: 'blue'
  end
end
