class RenameColumnAcquisitionIdToOrderId < ActiveRecord::Migration[4.2]
  def change
    rename_column :accesses, :acquisition_id, :order_id
    
    rename_column :cancellation_quizzes, :acquisition_id, :order_id
  end
end
