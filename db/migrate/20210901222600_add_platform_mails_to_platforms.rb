class AddPlatformMailsToPlatforms < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :mail_invite, :string
    add_column :platforms, :mail_grant_access, :string
  end
end
