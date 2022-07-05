class AddComplementaryPackagesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :complementary_package_ids, :integer, array: true, default: []
  end
end
