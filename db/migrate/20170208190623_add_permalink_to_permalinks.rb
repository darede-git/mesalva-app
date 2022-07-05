class AddPermalinkToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_reference :permalinks, :permalink, index: true, foreign_key: true
  end
end
