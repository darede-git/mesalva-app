# frozen_string_literal: true

class AddUtmToCrmEventsAndPermalinkEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :crm_events, :utm, :jsonb
    add_column :permalink_events, :utm, :jsonb
  end
end
