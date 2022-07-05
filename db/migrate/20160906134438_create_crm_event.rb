class CreateCrmEvent < ActiveRecord::Migration[4.2]
  def change
    create_table :crm_events do |t|
      t.string :event_type
      t.string :event_name
      t.string :timestamp
      t.string :user_id
      t.string :user_email
      t.string :user_name
      t.string :user_objective
      t.string :user_subscriber
      t.string :package_education_level
      t.string :order_price
      t.string :order_payment_type
      t.string :location
      t.string :platform
      t.string :browser
      t.string :device
      t.string :ref
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign
    end
  end
end
