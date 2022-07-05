class RemovePackageColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :packages, :iugu_plan_id
    remove_column :packages, :iugu_plan_identifier
  end
end
