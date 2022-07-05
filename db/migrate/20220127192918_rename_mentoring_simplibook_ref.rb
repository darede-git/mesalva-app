class RenameMentoringSimplibookRef < ActiveRecord::Migration[5.2]
  def change
    rename_column :mentorings, :simply_book_ref, :simplybook_id
    add_column :mentorings, :call_link, :string
  end
end
