class AddsErrorMessageToCrmEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :crm_events, :error_message, :string
  end
end
