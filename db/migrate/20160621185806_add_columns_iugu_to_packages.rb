class AddColumnsIuguToPackages < ActiveRecord::Migration[4.2]
  def change
    add_column :packages, :iugu_plan_id, :string
    add_column :packages, :iugi_plan_identifier, :string
  end
end
