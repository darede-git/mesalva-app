class CreateExerciseEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :exercise_events do |t|
      t.string :item_slug
      t.string :medium_slug
      t.string  :submission_token
      t.boolean :correct, default: false
      t.references :answer, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :exercise_events, [:item_slug, :user_id]
    add_index :exercise_events, [:submission_token]
  end
end
