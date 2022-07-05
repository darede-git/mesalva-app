class AddColumnSourceToPermalinkEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :permalink_events, :source_name, :string, default: 'default'
    add_column :permalink_events, :source_id, :string
  end
end
