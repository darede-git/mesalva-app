class AddEducationLevelToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :education_level_id, :integer
  end
end
