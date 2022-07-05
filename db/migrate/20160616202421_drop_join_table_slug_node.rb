class DropJoinTableSlugNode < ActiveRecord::Migration[4.2]
  def change
    drop_table :nodes_slugs
  end
end
