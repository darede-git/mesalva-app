class DropEventsTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :events
  end
end
