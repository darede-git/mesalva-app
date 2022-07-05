class DropDeprecatedForumStructure < ActiveRecord::Migration[4.2]
  def change
  	remove_column :comments, :topic_id
  	drop_table :topics
  	drop_table :subjects
  	drop_table :forums
  	drop_table :votes
  	drop_table :promotes
  end
end
