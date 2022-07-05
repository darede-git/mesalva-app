class AddLeadtimeToCorrectionStyle < ActiveRecord::Migration[4.2]
  def change
    add_column :correction_styles, :leadtime, :integer
  end
end
