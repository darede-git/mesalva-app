class AddsIndexToAccess < ActiveRecord::Migration[4.2]
  def change
      add_index :accesses, :starts_at
      add_index :accesses, :expires_at
      add_index :accesses, :active
  end
end
