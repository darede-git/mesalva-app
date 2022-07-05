class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.references :topic, index: true, foreign_key: true
      t.text :text
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end
