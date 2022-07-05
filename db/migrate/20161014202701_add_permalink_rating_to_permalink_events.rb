class AddPermalinkRatingToPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :permalink_events, :permalink_rating, :integer
  end
end
