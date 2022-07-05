class AddIndexToPermalinkEventsSlug < ActiveRecord::Migration[4.2]
  def change
    add_index :permalink_events, :permalink_slug
  end
end
