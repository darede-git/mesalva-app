# frozen_string_literal: true

class RemovePlatformsPublicAttribute < ActiveRecord::Migration[5.2]
  def change
    remove_column :platforms, :public, :boolean, default: false
  end
end
