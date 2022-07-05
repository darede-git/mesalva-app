class ChangeColumnPermalinkRate < ActiveRecord::Migration[4.2]
  def change
    rename_column :permalink_events, :permalink_rating, :content_rating
  end
end
