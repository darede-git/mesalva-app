# frozen_string_literal: true

class CreateCampaignEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_events do |t|
      t.integer :user_id, nullable: false
      t.integer :invited_by
      t.string :campaign_name, nullable: false
      t.string :event_name, nullable: false

      t.timestamps
    end
    add_index :campaign_events,
              %i[user_id campaign_name event_name],
              unique: true,
              name: 'index_campaign_events_user_id_campaign_name_event_name'
  end
end
