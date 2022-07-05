class CreateFaqTopics < ActiveRecord::Migration[4.2]
  def change
    create_table :faq_topics do |t|
      t.string :name
      t.string :slug
      t.string :token
      t.string :created_by
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
