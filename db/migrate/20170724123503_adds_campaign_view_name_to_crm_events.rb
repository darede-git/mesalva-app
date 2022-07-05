class AddsCampaignViewNameToCrmEvents < ActiveRecord::Migration[4.2]
  def change
  	add_column :crm_events, :campaign_view_name, :string
  end
end
