class AddItemToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_reference :permalinks, :item, index: true, foreign_key: true
  end
end
