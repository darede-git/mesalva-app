class AddMediumToPermalinks < ActiveRecord::Migration[4.2]
  def change
    add_reference :permalinks, :medium, index: true, foreign_key: true
  end
end
