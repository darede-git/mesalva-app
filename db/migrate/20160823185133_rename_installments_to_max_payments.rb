class RenameInstallmentsToMaxPayments < ActiveRecord::Migration[4.2]
  def change
    rename_column :packages, :installments, :max_payments
  end
end
