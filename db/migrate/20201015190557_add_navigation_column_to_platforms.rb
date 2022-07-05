# frozen_string_literal: true

class AddNavigationColumnToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :navigation, :jsonb, default: {}, null: false
  end
end
