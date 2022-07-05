class RemovePermalinkEventsColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :permalink_events, :ref
    remove_column :permalink_events, :utm_source
    remove_column :permalink_events, :utm_medium
    remove_column :permalink_events, :utm_term
    remove_column :permalink_events, :utm_content
    remove_column :permalink_events, :utm_campaign
  end
end
