class AddDescriptionPositionVideoToCorrectionStyleCriteria < ActiveRecord::Migration[5.2]
  def change
    add_column :correction_style_criteria, :description, :string
    add_column :correction_style_criteria, :position, :integer
    add_column :correction_style_criteria, :video_id, :string
  end
end
