# frozen_string_literal: true

class AddActiveOnUserPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :user_platforms, :active, :boolean, default: true
  end
end
