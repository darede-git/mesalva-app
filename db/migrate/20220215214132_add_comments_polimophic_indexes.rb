class AddCommentsPolimophicIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :comments, %i[active commentable_id commentable_type], name: 'index_comments_on_medium'
  end
end
