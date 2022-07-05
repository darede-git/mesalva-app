class AddIpAddressToCrmEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :crm_events, :ip_address, :string
  end
end
