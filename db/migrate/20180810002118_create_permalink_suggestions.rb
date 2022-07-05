class CreatePermalinkSuggestions < ActiveRecord::Migration[4.2]
  def change
    create_table :permalink_suggestions do |t|
      t.string :slug
      t.string :suggestion_slug
      t.string :suggestion_name

      t.timestamps null: false
    end
  end
end
