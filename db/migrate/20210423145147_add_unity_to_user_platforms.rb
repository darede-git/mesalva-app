# frozen_string_literal: true

class AddUnityToUserPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :user_platforms, :unity, :string
  end
end
