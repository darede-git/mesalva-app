class AddsPagarmeAttrsToPackagesAndUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :pagarme_customer_id, :string
    add_column :packages, :pagarme_plan_id, :string
  end
end
