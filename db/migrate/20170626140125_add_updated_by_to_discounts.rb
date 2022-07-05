class AddUpdatedByToDiscounts < ActiveRecord::Migration[4.2]
  def change
    add_column :discounts, :updated_by, :string
    remove_column :discounts, :packages
    remove_column :discounts, :upsell_package
    add_column :discounts, :packages, :string, array: true
    add_column :discounts, :upsell_packages, :string, array: true

    add_index :discounts, :packages
    add_index :discounts, :upsell_packages

    remove_reference :discounts, :users, index: true
    add_reference :discounts, :user, index: true
  end
end
