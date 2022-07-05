class AddStartsAtToPermalinkEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :permalink_events, :starts_at, :datetime
  end
end
