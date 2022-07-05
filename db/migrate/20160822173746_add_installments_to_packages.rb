class AddInstallmentsToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :installments, :integer, default: 1
  end
end
