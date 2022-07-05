class RenameColumnNodeVideoToVideo < ActiveRecord::Migration[4.2]
  def change
    rename_column :nodes, :node_video, :video
  end
end
