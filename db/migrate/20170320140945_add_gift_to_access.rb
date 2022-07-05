# frozen_string_literal: true
class AddGiftToAccess < ActiveRecord::Migration[4.2]
  def change
    add_column :accesses, :created_by, :string
    add_column :accesses, :gift, :boolean, default: false
  end
end
