class CreateNotificationEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_events do |t|
      t.integer :user_id
      t.integer :notification_id
      t.boolean :read, default: false

      t.timestamps
    end
    add_index :notification_events, :notification_id
  end
end
