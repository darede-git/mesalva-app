class RemoveEventTypeFromCrmEvents < ActiveRecord::Migration[4.2]
  def change
    remove_column :crm_events, :event_type, :string
  end
end
