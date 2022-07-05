class AlterCrmEventsColumnsType < ActiveRecord::Migration[4.2]
  def change
    change_column :crm_events, :user_id,  'integer USING CAST(user_id AS integer)'
    change_column :crm_events, :order_price,  'decimal USING CAST(order_price AS decimal)'
    change_column :crm_events, :user_subscriber,  'boolean USING CAST(user_subscriber AS boolean)'

    remove_column :crm_events, :timestamp

    add_column :crm_events, :created_at, :datetime, null: false
    add_column :crm_events, :user_objective_id, :integer
  end
end
