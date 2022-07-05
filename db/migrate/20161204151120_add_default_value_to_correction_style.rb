class AddDefaultValueToCorrectionStyle < ActiveRecord::Migration[4.2]
  def change
    change_column :correction_styles, :leadtime, :integer, :default => 10
  end
end
