# frozen_string_literal: true

class CreateEmailChanges < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :options, :jsonb, default: {}, nullable: false
  end
end
