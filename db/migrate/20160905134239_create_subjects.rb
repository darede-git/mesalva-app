class CreateSubjects < ActiveRecord::Migration[4.2]
  def change
    create_table :subjects do |t|
      t.references :forum, index: true, foreign_key: true
      t.references :node_module, index: true, foreign_key: true
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
