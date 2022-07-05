# frozen_string_literal: true

class ChangeMediaOptionsToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column :media, :options, :jsonb, default: {}, null: false
  end
end
