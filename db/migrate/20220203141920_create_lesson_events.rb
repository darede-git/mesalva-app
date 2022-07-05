class CreateLessonEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :lesson_events do |t|
      t.string :node_module_token
      t.string :node_module_slug
      t.string :item_token
      t.string :item_slug
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :lesson_events, [:node_module_slug, :user_id]
  end
end
