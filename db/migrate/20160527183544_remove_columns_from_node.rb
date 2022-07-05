class RemoveColumnsFromNode < ActiveRecord::Migration[4.2]
  def change
    remove_column :nodes, :free, :boolean
    remove_column :nodes, :url, :string
    remove_column :nodes, :file_data, :binary
    remove_column :nodes, :attachment, :string
    remove_column :nodes, :length, :decimal
    remove_column :nodes, :node_text, :text
    remove_column :nodes, :video_id, :integer
    remove_column :nodes, :provider, :string
    remove_column :nodes, :correction, :text
    remove_column :nodes, :matter, :string
    remove_column :nodes, :subject, :string
    remove_column :nodes, :difficulty, :string
    remove_column :nodes, :university, :string
    remove_column :nodes, :concourse, :string
    remove_column :nodes, :justification, :text
    remove_column :nodes, :correct, :boolean
  end
end
