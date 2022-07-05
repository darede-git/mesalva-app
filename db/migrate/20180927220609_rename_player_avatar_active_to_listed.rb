class RenamePlayerAvatarActiveToListed < ActiveRecord::Migration[4.2]
  def change
    rename_column :playlist_avatars, :active, :listed
  end
end
