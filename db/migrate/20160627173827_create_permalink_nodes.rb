class CreatePermalinkNodes < ActiveRecord::Migration[4.2]
  def change
    create_table :permalink_nodes do |t|
      t.belongs_to :permalink, index: true, foreign_key: true
      t.belongs_to :node, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
