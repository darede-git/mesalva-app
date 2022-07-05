class FixCorrectionStyleName < ActiveRecord::Migration[4.2]
  def change
    rename_column :correction_styles, :correction_style, :name
  end
end
