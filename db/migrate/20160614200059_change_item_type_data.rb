class ChangeItemTypeData < ActiveRecord::Migration[4.2]
  def change
    change_column(:acquisition_items, :item_type, :string)
  end
end
