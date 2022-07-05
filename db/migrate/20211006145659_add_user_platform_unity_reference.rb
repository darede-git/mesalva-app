class AddUserPlatformUnityReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_platforms, :platform_unity
    remove_column :platform_unities, :user_platforms_id
  end
end
