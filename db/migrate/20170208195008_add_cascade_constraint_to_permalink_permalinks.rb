class AddCascadeConstraintToPermalinkPermalinks < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :permalinks, :permalinks
    add_foreign_key :permalinks, :permalinks, on_delete: :cascade
  end
end
