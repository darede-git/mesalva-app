class AddTimestampsToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :starts_at, :datetime
    add_column :items, :ends_at, :datetime
  end
end
