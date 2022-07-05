class AddIndexToConfirmedAt < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :confirmed_at
    add_index :teachers, :confirmed_at
    add_index :admins, :confirmed_at
  end
end
