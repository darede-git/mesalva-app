class CreateTopics < ActiveRecord::Migration[4.2]
  def change
    create_table :topics do |t|
      t.references :topicable, polymorphic: true, index: true
      t.references :forum, index: true, foreign_key: true
      t.references :subject, index: true, foreign_key: true
      t.string :title
      t.text :text
      t.string :slug
      t.boolean :active, default: true, null: false

      t.timestamps null: false
    end
  end
end
