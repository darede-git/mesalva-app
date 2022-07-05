class AddMediumIdToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :medium_id, :integer
  end
end
