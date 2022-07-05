class DropTableExercisesItems < ActiveRecord::Migration[4.2]
  def change
    drop_table :exercises_items
  end
end
