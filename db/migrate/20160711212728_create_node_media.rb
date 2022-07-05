class CreateNodeMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :node_media do |t|
      t.belongs_to :node, index: true, foreign_key: true
      t.belongs_to :medium, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
