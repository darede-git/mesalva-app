class AddsIndexToTopic < ActiveRecord::Migration[4.2]
  def change
    add_index :topics, [:slug, :forum_id], :unique => true
  end
end
