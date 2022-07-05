class AddUserCountersFields < ActiveRecord::Migration[5.2]
  def change
    add_column :user_counters, :streaming, :integer
  end
end
