class DropPermalinkItem < ActiveRecord::Migration[4.2]
  def change
    drop_table :permalink_items
  end
end
