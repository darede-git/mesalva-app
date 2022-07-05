class AddsActiveToCorrectionStyle < ActiveRecord::Migration[4.2]
  def change
    add_column :correction_styles, :active, :boolean, :default => true
    add_index :correction_styles, :active
  end
end
