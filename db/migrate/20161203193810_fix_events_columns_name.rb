class FixEventsColumnsName < ActiveRecord::Migration[4.2]
  def change
    rename_column :permalink_events, :client, :user_agent
    rename_column :permalink_events, :platform, :client

    rename_column :crm_events, :browser, :user_agent
    rename_column :crm_events, :platform, :client
  end
end
