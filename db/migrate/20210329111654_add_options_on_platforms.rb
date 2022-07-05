# frozen_string_literal: true

class AddOptionsOnPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :options, :jsonb, default: {}
  end
end
