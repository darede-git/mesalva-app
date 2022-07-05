class ChangeColumnsPermissions < ActiveRecord::Migration[5.2]
  def change
    rename_column :permissions, :controller_name, :context
    add_column :permissions, :expires_at_suggestion , :datetime
    add_column :permissions, :permission_type  , :string
  end
end
