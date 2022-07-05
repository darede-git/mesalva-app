# frozen_string_literal: true

class AddDedicatedEssayToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :dedicated_essay, :boolean, default: false
  end
end
