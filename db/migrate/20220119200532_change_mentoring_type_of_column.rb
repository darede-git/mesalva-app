class ChangeMentoringTypeOfColumn < ActiveRecord::Migration[5.2]
  def change

    change_column :mentorings, :comment, :text

    change_column :mentorings, :simply_book_ref, :integer, using: 'simply_book_ref::integer'

  end
end
