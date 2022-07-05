class ChangeVideoIdType < ActiveRecord::Migration[4.2]
  def change
    change_column :media, :video_id, :string
  end
end
