class CreateJoinTableItemExercise < ActiveRecord::Migration[4.2]
  def change
    create_join_table :items, :exercises do |_t|
      # t.index [:item_id, :exercise_id]
      # t.index [:exercise_id, :item_id]
    end
  end
end
