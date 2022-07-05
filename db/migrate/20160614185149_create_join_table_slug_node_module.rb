class CreateJoinTableSlugNodeModule < ActiveRecord::Migration[4.2]
  def change
    create_join_table :slugs, :node_modules do |t|
      t.index [:slug_id, :node_module_id]
      t.index [:node_module_id, :slug_id]
    end
  end
end
