class AddRoleTypeToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :role_type, :string, default: 'admin'
  end
end
