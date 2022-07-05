class RemovesEducationSegmentIdFromPackages < ActiveRecord::Migration[4.2]
  def change
  	remove_column :packages, :education_segment_id
  end
end
