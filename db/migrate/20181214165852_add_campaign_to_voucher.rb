class AddCampaignToVoucher < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :campaign, :string
  end
end
