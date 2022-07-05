class CreateFaqs < ActiveRecord::Migration[4.2]
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.string :image
      t.string :created_by
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
