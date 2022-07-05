class RenameEducationLevelToEducationSegment < ActiveRecord::Migration[4.2]
  def change
    remove_column :packages, :education_level_id

    add_column :packages, :education_segment_id, :integer
    add_index :packages, :education_segment_id
  end
end
