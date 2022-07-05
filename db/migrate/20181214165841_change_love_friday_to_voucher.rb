class ChangeLoveFridayToVoucher < ActiveRecord::Migration[5.2]
  def change
    rename_table :love_fridays, :vouchers
  end
end
