# frozen_string_literal: true

class AddPlatformIdToImages < ActiveRecord::Migration[5.2]
  def change
    add_reference :images, :platform, foreign_key: true
    add_column :images, :created_by, :string
  end
end
