class AddTimestampToMediumRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :medium_ratings, :created_at , :datetime
    add_column :medium_ratings, :updated_at  , :datetime
  end
end
