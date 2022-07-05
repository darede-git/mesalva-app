class ChangeColumnEventType < ActiveRecord::Migration[4.2]
  def change
    rename_column :permalink_events, :event_type, :event_name
  end
end
