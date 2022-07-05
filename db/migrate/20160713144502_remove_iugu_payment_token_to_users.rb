class RemoveIuguPaymentTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :iugu_payment_token
  end
end
