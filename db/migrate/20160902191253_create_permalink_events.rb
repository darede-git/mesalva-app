class CreatePermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :permalink_events do |t|
      t.string :permalink_slug
      t.string :permalink_nodes, array: true
      t.string :permalink_node_module
      t.string :permalink_item
      t.string :permalink_medium
      t.integer :permalink_node_ids, array: true
      t.integer :permalink_node_module_id
      t.integer :permalink_item_id
      t.integer :permalink_medium_id
      t.string :permalink_node_types, array: true
      t.string :permalink_item_type
      t.string :permalink_medium_type
      t.string :permalink_node_slugs, array: true
      t.string :permalink_node_module_slug
      t.string :permalink_item_slug
      t.string :permalink_medium_slug
      t.integer :permalink_answer_id
      t.boolean :permalink_answer_correct
      t.integer :user_id
      t.string :user_name
      t.string :user_email
      t.boolean :user_subscriber
      t.string :user_objective
      t.integer :user_objective_id
      t.string :event_type
      t.datetime :created_at, null: false
      t.string :location
      t.string :platform
      t.string :device
      t.string :client
      t.string :ref
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign
    end
  end
end
