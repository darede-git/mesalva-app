# frozen_string_literal: true

class AddOptionsToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :options, :jsonb
  end
end
