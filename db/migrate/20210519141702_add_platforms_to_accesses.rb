# frozen_string_literal: true

class AddPlatformsToAccesses < ActiveRecord::Migration[5.2]
  def change
    add_reference :accesses, :platform, foreign_key: true
  end
end
