class RenameColumnInObjectives < ActiveRecord::Migration[4.2]
  def change
    rename_column :objectives, :product_slug, :education_segment_slug
  end
end
