class RemovePhoneNumberToUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :phone_number
    remove_column :users, :area_code
  end
end
