class AddRemainingDaysToAccesses < ActiveRecord::Migration[4.2]
  def change
    add_column :accesses, :remaining_days, :integer
  end
end
