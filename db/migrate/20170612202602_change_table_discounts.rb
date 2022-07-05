class ChangeTableDiscounts < ActiveRecord::Migration[4.2]
  def change
    remove_column :discounts, :package_id
    remove_column :discounts, :percentual_discount
    remove_column :discounts, :rule
    remove_column :discounts, :package_ids

    add_column :discounts, :packages, :string
    add_column :discounts, :percentual, :integer
    add_column :discounts, :code, :string
    add_column :discounts, :description, :text
    add_column :discounts, :upsell_package, :string
    add_column :discounts, :created_by, :string

    add_reference :discounts, :users, index: true
    add_index :discounts, :code
  end
end
