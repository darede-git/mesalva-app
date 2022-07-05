class AddExerciseEventsPosition < ActiveRecord::Migration[5.2]
  def change
    add_column :exercise_events, :position, :integer, default: 0
  end
end
