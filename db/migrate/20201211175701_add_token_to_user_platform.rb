# frozen_string_literal: true

class AddTokenToUserPlatform < ActiveRecord::Migration[5.2]
  def change
    add_column :user_platforms, :token, :string
  end
end
