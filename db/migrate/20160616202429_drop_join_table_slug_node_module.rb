class DropJoinTableSlugNodeModule < ActiveRecord::Migration[4.2]
  def change
    drop_table :node_modules_slugs
  end
end
