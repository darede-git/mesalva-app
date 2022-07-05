# frozen_string_literal: true

class InternalLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :internal_logs do |t|
      t.jsonb :log
      t.string :category
      t.string :log_type

      t.timestamps
    end
  end
end
