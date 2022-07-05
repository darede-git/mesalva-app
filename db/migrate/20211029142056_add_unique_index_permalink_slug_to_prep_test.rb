class AddUniqueIndexPermalinkSlugToPrepTest < ActiveRecord::Migration[5.2]
  def change
    remove_index :prep_tests, :permalink_slug
    add_index :prep_tests, :permalink_slug, unique: true
  end
end
