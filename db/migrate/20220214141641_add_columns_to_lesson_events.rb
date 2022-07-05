class AddColumnsToLessonEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :lesson_events, :submission_token, :string
    remove_column :lesson_events, :item_token
    remove_column :lesson_events, :node_module_token
  end
end
