class AddLessonEventsIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :lesson_events, [:node_module_slug, :user_id, :submission_token],
              name: 'index_lesson_events_on_module_and_user_and_token'
  end
end
