# frozen_string_literal: true
class CreateForm < ActiveRecord::Migration[4.2]
  def change
    create_table :forms do |t|
      t.string :user_uid
      t.string :metadata, array: true
      t.string :token
      t.boolean :completed
    end

    add_index :forms, [:user_uid, :token], unique: true
  end
end
