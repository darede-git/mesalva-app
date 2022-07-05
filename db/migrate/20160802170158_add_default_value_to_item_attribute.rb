class AddDefaultValueToItemAttribute < ActiveRecord::Migration[4.2]
  def change
    change_column :items, :free, :boolean, :default => false
  end
end
