class RenameColumnIugiToIugu < ActiveRecord::Migration[4.2]
  def change
   rename_column :packages, :iugi_plan_identifier, :iugu_plan_identifier
  end
end
