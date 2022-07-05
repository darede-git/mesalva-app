class DropPermalinkMedium < ActiveRecord::Migration[4.2]
  def change
    drop_table :permalink_media
  end
end
