# frozen_string_literal: true

class AddPanelToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :panel, :jsonb, default: {}
  end
end
