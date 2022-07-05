class AddsAuditStatusToMedia < ActiveRecord::Migration[4.2]
  def change
  	add_column :media, :audit_status, :string
  end
end
