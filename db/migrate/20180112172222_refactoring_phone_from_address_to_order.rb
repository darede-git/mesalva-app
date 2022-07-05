class RefactoringPhoneFromAddressToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :phone_area, :string
    add_column :orders, :phone_number, :string

    add_column :users, :phone_area, :string
    add_column :users, :phone_number, :string
  end
end
