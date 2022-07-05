class CreateMentoring < ActiveRecord::Migration[5.2]
  def change
    create_table :mentorings do |t|
      t.string :title
      t.integer :status
      t.references :user, foreign_key: true
      t.references :content_teacher, foreign_key: true
      t.string :comment
      t.integer :rating
      t.datetime :starts_at
      t.string :simply_book_ref
    end
  end
end
