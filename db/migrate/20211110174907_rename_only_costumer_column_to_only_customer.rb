class RenameOnlyCostumerColumnToOnlyCustomer < ActiveRecord::Migration[5.2]
  def change
    rename_column :discounts, :only_costumer, :only_customer
  end
end
