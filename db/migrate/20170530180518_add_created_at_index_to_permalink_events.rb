class AddCreatedAtIndexToPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    add_index :permalink_events, :created_at
  end
end
