class AddCrmNameToObjectives < ActiveRecord::Migration[5.2]
  def change
    add_column :objectives, :crm_name, :string
  end
end
