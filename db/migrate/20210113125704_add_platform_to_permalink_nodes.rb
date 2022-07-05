class AddPlatformToPermalinkNodes < ActiveRecord::Migration[5.2]
  def change
    add_reference :nodes, :platform, foreign_key: true
    add_reference :node_modules, :platform, foreign_key: true
    add_reference :items, :platform, foreign_key: true
    add_reference :media, :platform, foreign_key: true
  end
end
