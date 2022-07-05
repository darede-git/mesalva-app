class AddReprocessedToOrderPayment < ActiveRecord::Migration[5.2]
  def up
    add_column :order_payments, :reprocessed, :bool, default: false

    execute <<-SQL
      UPDATE order_payments
      SET reprocessed = false
      WHERE reprocessed IS NULL
    SQL
  end
end
