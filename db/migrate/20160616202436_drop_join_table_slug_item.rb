class DropJoinTableSlugItem < ActiveRecord::Migration[4.2]
  def change
   drop_table :items_slugs 
  end
end
